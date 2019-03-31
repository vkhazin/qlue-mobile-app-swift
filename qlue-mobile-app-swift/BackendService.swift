//
//  BackendService.swift
//  qlue-mobile-app-swift
//
//  Created by vedran on 27/03/2019.
//  Copyright © 2019 ICS Solutions. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BackendService {
    
    class func updateLocationChange(locationManager: CLLocationManager, locations: [CLLocation], applicationState: String) -> [Any] {
        
        var dictSubmitted: [Any] = []

//        for location in locations {
        if let location = locations.last {
        
            let locationInfo: [String : Any] = [
                "altitudeAccuracy": location.verticalAccuracy, // *** there is no altitudeAccuracy in API ***
                "accuracy": location.horizontalAccuracy,
                "heading": locationManager.heading?.trueHeading ?? 0.0,
                "longitude": location.coordinate.longitude,
                "altitude": location.altitude,
                "latitude": location.coordinate.latitude,
                "speed": location.speed,
                "timestamp": 1000 * location.timestamp.timeIntervalSince1970,
                
                "geoPoint": NSNumber(value: location.coordinate.latitude).stringValue + "," + NSNumber(value: location.coordinate.longitude).stringValue,
                ]
            let dateFormatter = ISO8601DateFormatter()
            var formatOptions = dateFormatter.formatOptions
            formatOptions.insert([.withFractionalSeconds])
            dateFormatter.formatOptions = formatOptions
            let timestamp = dateFormatter.string(from: location.timestamp) //"2019-03-26T01:07:42.329Z"
            
            let dict:  [String : Any] = [
                "locationInfo": locationInfo,
                "timestamp": timestamp,
                
                // DEBUG
                "updateType": applicationState,
                "dateSubmitted": dateFormatter.string(from: Date())
            ]
            dictSubmitted.append(dict)
        }

        do {
            var processing = true
            let data = try JSONSerialization.data(withJSONObject: dictSubmitted, options: [])
            let submitDate = Date()
            
            var bgTask: UIBackgroundTaskIdentifier = .invalid
            var task: URLSessionDataTask?
            
            bgTask = UIApplication.shared.beginBackgroundTask {
                if processing {
                    NSLog("Cancel HTTP request")
                    task?.cancel()
                    processing = false
                }
            }

            BackendService.HTTPPostJSON(url: Config.isProduction ? Config.Production.Backend.url : Config.Development.Backend.url, data: data) { (err, result) in
                let responseDate = Date()
                if(err != nil){
                    print("\(responseDate): failure submitted: \(submitDate) with error \"\(err!.localizedDescription)\": \(dictSubmitted)")
                } else {
                    print("\(responseDate): success submitted: \(submitDate): \(dictSubmitted) responded: \(String(describing: result))")
                }
                processing = false
                task = nil
            }
            
            while(processing) {
                NSLog("sleep")
                Thread.sleep(forTimeInterval: 0.1)
            }
            UIApplication.shared.endBackgroundTask(bgTask)
            bgTask = .invalid
            
        }
        catch {
            print(error)
        }

        return dictSubmitted
    }
    
    //Method just to execute request, assuming the response type is string (and not file)
    fileprivate class func HTTPsendRequest(request: URLRequest,
                         callback: @escaping (Error?, String?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            if (err != nil) {
                callback(err,nil)
            } else {
                callback(nil, String(data: data!, encoding: String.Encoding.utf8))
            }
        }
        task.resume()
        
        return task
    }
    
    // post JSON
    fileprivate class func HTTPPostJSON(url: String,  data: Data,
                      callback: @escaping (Error?, String?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data
        return HTTPsendRequest(request: request, callback: callback)
    }
}
