# qlue-mobile-app-swift

## Requirements

* Create a background task based on location change e.g. every 500 meters
* Post json with the following format:
```
{
    "locationInfo": {
      "altitudeAccuracy": 13.696393966674805,
      "accuracy": 65,
      "heading": 45,
      "longitude": -79.48311321231225,
      "altitude": 234.0982666015625,
      "latitude": 43.85535658406261,
      "speed": 12,
      "timestamp": 1553562404521.051,
      "geoPoint": "43.85535658406261,-79.48311321231225"
    }
    "timestamp": "2019-03-26T01:07:42.329Z"
  }
 ```
 * To the end-point: POST https://gsqztydwpe.execute-api.us-east-1.amazonaws.com/latest
 * Demonstrate that the background task sends updates when:
 1. the app is in the foreground
 2. the app is in the background
 3. the device is in the stand-by mode e.g. the screen is dark
 4. no special actions by end user is required to keep updating the location

## How to contribute

* Fork the repo
* Commit changes to your own repo
* Submit a pull-request back to this repo when complete