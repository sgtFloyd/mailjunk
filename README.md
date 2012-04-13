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
    GET localhost:4567/count?status=2.0.0&day=2011.1.1
```json
{
    "query": [
        "mailjunk:status:2.0.0",
        "mailjunk:day:2011.1.1"
    ],
    "count": 30524
}
```
-
    GET localhost:4567/count?result=delivered&month=2011.1&domain=gmail.com

```json
{
    "query": [
        "mailjunk:delivered",
        "mailjunk:month:2011.1",
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
    GET localhost:4567/by_day?month=2011.1&result=delivered
```json
{
    "query": [
        "by_day",
        "mailjunk:month:2011.1",
        "mailjunk:delivered"
    ],
    "days": {
        "2011.1.1": 30524,
        "2011.1.10": 61410,
        "2011.1.11": 46994,
        "2011.1.12": 48337,
        "2011.1.13": 55070,
        "2011.1.14": 44310,
        "2011.1.15": 25831,
        "2011.1.16": 24597,
        "2011.1.17": 38720,
        "2011.1.18": 52654,
        "2011.1.19": 54932,
        "2011.1.2": 33968,
        "2011.1.20": 49085,
        "2011.1.21": 41548,
        "2011.1.24": 2,
        "2011.1.25": 7539,
        "2011.1.26": 22125,
        "2011.1.27": 53372,
        "2011.1.28": 55729,
        "2011.1.29": 24533,
        "2011.1.3": 51435,
        "2011.1.30": 31126,
        "2011.1.31": 22645,
        "2011.1.4": 53576,
        "2011.1.5": 68743,
        "2011.1.6": 57683,
        "2011.1.7": 55177,
        "2011.1.8": 27143,
        "2011.1.9": 33241
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
        "2011.1": 2135,
        "2011.2": 2058,
        "2011.3": 859
    }
}
```