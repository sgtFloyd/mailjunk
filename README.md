Index PowerMTA accounting files in redis for fast querying.

To index:
    ruby junker.rb accounting-file1.csv account-file2.csv ...

To run:
    ruby mailjunk.rb

Example queries:
    /count?result=bounced&domain=gmail.com
    /count?status=2.0.0&day=2011.1.1
    /count?result=delivered&month=2011.1&domain=gmail.com

    /by_result
    /by_day?month=2011.01&result=delivered
    /by_month?result=bounced&domain=gmail.com
    /by_result?domain=gmail.com
    /by_status?domain=hotmail.com