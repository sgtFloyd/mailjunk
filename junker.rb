(puts 'usage: ruby junker.rb [file ...]'; exit) unless ARGV.size > 0

require 'csv'
require 'digest'
require 'redis'
require 'time'

# Sets:
#   mailjunk:statuses           set of all bounce codes indexed
#   mailjunk:domains            set of all domains indexed
#   mailjunk:months             set of all months indexed
#   mailjunk:days               set of all days indexed
#
#   mailjunk:delivered          set of row ids with delivered status
#   mailjunk:bounced            set of row ids with bounced status
#
#   mailjunk:domain:gmail.com   set of row ids with gmail.com domain
#   mailjunk:status:2.0.0       set of row ids with 2.0.0 status
#   mailjunk:month:2012.04      set of row ids sent in April, 2012
#   mailjunk:day:2012.04.01     set of row ids sent on April 1, 2012

$redis = Redis.new

COLUMN = {
  type: 0,              timeLogged: 1,         timeQueued: 2,         timeImprinted: 3,
  orig: 4,              rcpt: 5,               orcpt: 6,              dsnAction:     7,
  dsnStatus: 8,         dsnDiag: 9,            dsnMta: 10,            bounceCat:     11,
  srcType: 12,          srcMta: 13,            dlvType: 14,           lvSourceIp:    15,
  dlvDestinationIp: 16, dlvEsmtpAvailable: 17, dlvSize: 18,           vmta:          19,
  jobId: 20,            envId: 21,             header_Message_Id: 22 }

def process_type(uid, row)
  type = row[COLUMN[:type]]
  ($redis.sadd("mailjunk:delivered", uid); return true) if type == 'd'
  ($redis.sadd("mailjunk:bounced",   uid); return true) if type == 'b'
  false
end

def process_time(uid, row)
  t = Time.parse(row[COLUMN[:timeLogged]])
  day = "#{t.year}.#{t.month}.#{t.day}"
  mon = "#{t.year}.#{t.month}"

  $redis.sadd("mailjunk:days",   day)
  $redis.sadd("mailjunk:months", mon)
  $redis.sadd("mailjunk:day:#{day}",   uid)
  $redis.sadd("mailjunk:month:#{mon}", uid)
end

def process_status(uid, row)
  stat = row[COLUMN[:dsnStatus]].split(' ').first

  $redis.sadd("mailjunk:statuses", stat)
  $redis.sadd("mailjunk:status:#{stat}", uid)
end

def process_domain(uid, row)
  dom = row[COLUMN[:rcpt]].split('@').last

  $redis.sadd("mailjunk:domains", dom)
  $redis.sadd("mailjunk:domain:#{dom}", uid)
end

# generate unique id for given row
def uid(row)
  Digest::SHA1.hexdigest(row.to_s)
end

ARGV.each do |file|
  puts "Processing #{file}"
  CSV.foreach(file) do |row|
    uid = uid(row)
    next unless process_type(uid, row) # skip header row
    process_time(uid, row)
    process_status(uid, row)
    process_domain(uid, row)
  end
end
