//
//  BackendService.swift
//  qlue-mobile-app-swift
//
//  Created by vedran on 27/03/2019.
//  Copyright © 2019 ICS Solutions. All rights reserved.
//

import Foundation
import CoreLocation

class BackendService {
    
    class func updateLocationChange(locationManager: CLLocationManager, locations: [CLLocation]) -> [String : Any]? {
        
        var dictSubmitted: [String : Any]? = nil

        if let location = locations.last {
            
            do {
                
                let locationInfo: [String : Any] = [
                    "altitudeAccuracy": location.verticalAccuracy, // *** there is no altitudeAccuracy in API ***
                    "accuracy": location.horizontalAccuracy,
                    "heading": locationManager.heading?.trueHeading ?? 0.0,
                    "longitude": location.coordinate.longitude,
                    "altitude": location.altitude,
                    "latitude": location.coordinate.latitude,
                    "speed": location.speed,
                    "timestamp": location.timestamp.timeIntervalSince1970, //1553562404521.051 vs 1553688405.998379
                    
                    "geoPoint": NSNumber(value: location.coordinate.latitude).stringValue + "," + NSNumber(value: location.coordinate.longitude).stringValue,
                    ]
                let dateFormatter = ISO8601DateFormatter()
                var formatOptions = dateFormatter.formatOptions
                formatOptions.insert([.withFractionalSeconds])
                dateFormatter.formatOptions = formatOptions
                let timestamp = dateFormatter.string(from: location.timestamp) //"2019-03-26T01:07:42.329Z"
                
                let dict:  [String : Any] = [
                    "locationInfo": locationInfo,
                    "timestamp": timestamp
                ]
                let data = try JSONSerialization.data(withJSONObject: dict, options: [])
                let submitDate = Date()
                dictSubmitted = dict
                
                BackendService.HTTPPostJSON(url: Config.Production.Backend.url, data: data) { (err, result) in
                    let responseDate = Date()
                    if(err != nil){
                        print("\(responseDate): failure submitted: \(submitDate) with error \"\(err!.localizedDescription)\": \(dict)")
                    }
                    print("\(responseDate): success submitted: \(submitDate): \(dict)")
                }
            }
            catch {
                print(error)
            }
            
        }

        return dictSubmitted
    }
    
    //Method just to execute request, assuming the response type is string (and not file)
    fileprivate class func HTTPsendRequest(request: URLRequest,
                         callback: @escaping (Error?, String?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            if (err != nil) {
                callback(err,nil)
            } else {
                callback(nil, String(data: data!, encoding: String.Encoding.utf8))
            }
        }
        task.resume()
    }
    
    // post JSON
    fileprivate class func HTTPPostJSON(url: String,  data: Data,
                      callback: @escaping (Error?, String?) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data
        HTTPsendRequest(request: request, callback: callback)
    }
}
