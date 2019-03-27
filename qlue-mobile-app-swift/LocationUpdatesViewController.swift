//
//  LocationUpdatesViewController.swift
//  qlue-mobile-app-swift
//
//  Created by vedran on 27/03/2019.
//  Copyright © 2019 ICS Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class LocationUpdatesViewController: UIViewController {

    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var log: UITextView!
    
    func trackAlways() -> Bool { return false }
    
    let locationService = LocationService()
    
    var isUpdating = false
    
    @IBAction func didPressStart(_ sender: Any) {
        
        self.log.text = self.log.text + String(describing: NSDate()) + "\n"
        
        if locationService.startReceivingLocationChanges(onLocationUpdate: { (locationManager: CLLocationManager, locations: [CLLocation]) in
            
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
                    
                    self.HTTPPostJSON(url: Config.Production.Backend.url, data: data) { (err, result) in
                        if(err != nil){
                            print("failure: " + err!.localizedDescription)
                        }
                        print("success: " + (result ?? ""))
                    }
                }
                catch {
                    print(error)
                }
                
                self.log.text = self.log.text + "(" + String(describing: location.coordinate.latitude)+String(describing: location.coordinate.longitude)+")\n"
                
                self.scrollTextViewToBottom(textView: self.log)
                
            }
        }) {
            self.isUpdating = true
            
            self.start.isEnabled = false
            self.stop.isEnabled = true
        } else {
            self.isUpdating = false
            
            self.start.isEnabled = true
            self.stop.isEnabled = false
        }
    }
    
    @IBAction func didPressStop(_ sender: Any) {
        locationService.stopReceivingLocationChanges()
        
        self.log.text = self.log.text + "\n"
        
        self.isUpdating = false
        self.start.isEnabled = true
        self.stop.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.isUpdating {
            self.requestAuthorisation(onWhenInUse: {
                self.start.isEnabled = true
                self.stop.isEnabled = false
            }, onAlways: {
                self.start.isEnabled = true
                self.stop.isEnabled = false
            }) {
                self.start.isEnabled = false
                self.stop.isEnabled = false
            }
        }
    }
    
    // override point for always/when-in-use updates
    
    func requestAuthorisation( onWhenInUse: (() -> Void)? = nil, onAlways: (() -> Void)? = nil, onDenial: (() -> Void)? = nil) {
    }

    // automatically scroll to the end of the field
    
    internal func scrollTextViewToBottom(textView: UITextView) {
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSMakeRange(location, 1)
            textView.scrollRangeToVisible(bottom)
        }
    }
    
}

// backend communication

extension LocationUpdatesViewController {
    
    //Method just to execute request, assuming the response type is string (and not file)
    func HTTPsendRequest(request: URLRequest,
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
    func HTTPPostJSON(url: String,  data: Data,
                      callback: @escaping (Error?, String?) -> Void) {
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data
        HTTPsendRequest(request: request, callback: callback)
    }

}
