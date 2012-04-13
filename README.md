Index PowerMTA accounting files in redis for fast querying.

**Generate index**: `ruby junker.rb accounting-file1.csv account-file2.csv ...`

**Run Webserver**: `ruby mailjunk.rb`

**Example queries**:

    GET localhost:4567/count?result=bounced&domain=gmail.com
```json
{
    "query": [
        "mailjunk:bounced",
        "mailjunk:domain:gmail.com"
    ],
    "count": 5052
}
```
-
    GET localhost:4567/count?status=2.0.0&day=2011.01.01
```json
{
    "query": [
        "mailjunk:status:2.0.0",
        "mailjunk:day:2011.01.01"
    ],
    "count": 30524
}
```
-
    GET localhost:4567/count?result=delivered&month=2011.01&domain=gmail.com

```json
{
    "query": [
        "mailjunk:delivered",
        "mailjunk:month:2011.01",
        "mailjunk:domain:gmail.com"
    ],
    "count": 277607
}
```
-
    GET localhost:4567/by_result
```json
{
    "query": [
        "by_result"
    ],
    "results": {
        "bounced": 104746,
        "delivered": 2853514
    }
}
```
-
    GET localhost:4567/by_result?domain=gmail.com
```json
{
    "query": [
        "by_result",
        "mailjunk:domain:gmail.com"
    ],
    "results": {
        "bounced": 5052,
        "delivered": 674373
    }
}
```
-
    GET localhost:4567/by_status?domain=hotmail.com
```json
{
    "query": [
        "by_status",
        "mailjunk:domain:hotmail.com"
    ],
    "statuses": {
        "2.0.0": 168643,
        "5.0.0": 3461
    }
}
```
-
    GET localhost:4567/by_day?month=2011.01&result=delivered
```json
{
    "query": [
        "by_day",
        "mailjunk:month:2011.01",
        "mailjunk:delivered"
    ],
    "days": {
        "2011.01.01": 30524,
        "2011.01.02": 33968,
        "2011.01.03": 51435,
        "2011.01.04": 53576,
        "2011.01.05": 68743,
        "2011.01.06": 57683,
        "2011.01.07": 55177,
        "2011.01.08": 27143,
        "2011.01.09": 33241,
        "2011.01.10": 61410,
        "2011.01.11": 46994,
        "2011.01.12": 48337,
        "2011.01.13": 55070,
        "2011.01.14": 44310,
        "2011.01.15": 25831,
        "2011.01.16": 24597,
        "2011.01.17": 38720,
        "2011.01.18": 52654,
        "2011.01.19": 54932,
        "2011.01.20": 49085,
        "2011.01.21": 41548,
        "2011.01.24": 2,
        "2011.01.25": 7539,
        "2011.01.26": 22125,
        "2011.01.27": 53372,
        "2011.01.28": 55729,
        "2011.01.29": 24533,
        "2011.01.30": 31126,
        "2011.01.31": 22645
    }
}
```
-
    GET localhost:4567/by_month?result=bounced&domain=gmail.com
```json
{
    "query": [
        "by_month",
        "mailjunk:bounced",
        "mailjunk:domain:gmail.com"
    ],
    "months": {
        "2011.01": 2135,
        "2011.02": 2058,
        "2011.03": 859
    }
}
```