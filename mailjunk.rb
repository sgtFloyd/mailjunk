require 'haml'
require 'json'
require 'redis'
require 'sinatra'

get '/' do
  haml :index
end

get '/count' do
  content_type :json
  { :query => Mailjunk.parse_opts(params),
    :count => Mailjunk.count(params)
  }.to_json
end

get '/by_:type' do
  content_type :json
  type = params.delete('type')
  results = Mailjunk.count_by(type, params)
  { :query => ["by_#{type}"] + Mailjunk.parse_opts(params),
    :count => results.count,
    Mailjunk.plural(type) => results
  }.to_json
end

class Mailjunk
  PREFIX = 'mailjunk'
  AVAILABLE_KEYS = [:result, :day, :month, :status, :domain]
  @@redis = Redis.new
  class << self

    # parse options into keys for redis sets
    #
    #   parse_opts(:result => 'bounced', :status => '4.0.0', :domain => 'gmail.com', :month  => '2011.2')
    #   => ['mailjunk:bounced', 'mailjunk:status:4.0.0', 'mailjunk:domain:gmail.com', 'mailjunk:month:2011.2']
    #
    # available keys:
    #   :result => 'delivered' || 'bounced'
    #   :day    => '2011.4.19'
    #   :month  => '2011.4'
    #   :status => '2.0.0'
    #   :domain => 'gmail.com'
    #
    def parse_opts(options)
      options.inject([]){|keys, (key, val)|
        next(keys) unless AVAILABLE_KEYS.include?(key.to_sym)
        keys << (key.to_s == 'result' ? "#{PREFIX}:#{val}" : "#{PREFIX}:#{key}:#{val}")
      }
    end

    # combine options into a unique compound key
    #
    #   compound_key(:result => 'bounced', :status => '4.0.0', :domain => 'gmail.com', :month  => '2011.2')
    #   => "mailjunk:result:bounced&status:4.0.0&domain:gmail.com&month:2011.2"
    #
    def compound_key(options)
      options.inject("#{PREFIX}:"){|key, (k,v)|
        next(key) unless AVAILABLE_KEYS.include?(k.to_sym)
        key << "#{k}:#{v}&"
      }.chomp('&')
    end

    # pluralize a key name
    def plural(key)
      key.to_s == 'status' ? "#{key}es" : "#{key}s"
    end

    def count(options)
      keys = parse_opts(options)
      if keys.length == 1
        @@redis.scard(*keys)
      else
        compound_key = compound_key(options)
        @@redis.sinterstore(compound_key, *keys)
        @@redis.scard(compound_key)
      end
    end

    def count_by(type, options={})
      if type.to_s == 'result'
        ['bounced', 'delivered'].inject([]){|res, key|
          res << {type => key, count => Mailjunk.count(options.merge(type => key))}
        }
      else
        Mailjunk.indexed_keys(type).inject([]){|res, key|
          count = Mailjunk.count(options.merge(type => key))
          res << {type => key, :count => count} unless count == 0; res
        }.sort{|a,b| a[type] <=> b[type]}
      end
    end

    def indexed_keys(type)
      return [] unless AVAILABLE_KEYS.include?(type.to_sym)
      @@redis.smembers("#{PREFIX}:#{plural(type)}")
    end

  end
end
