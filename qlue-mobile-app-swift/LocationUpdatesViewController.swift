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

    @IBOutlet weak var autoScroll: UISwitch!
    @IBOutlet weak var log: UITextView!

    let locationService = LocationService()
    
    var isUpdating = false
    var logText = ""
    
    func startTracking() {
        
        logText += String(describing: NSDate()) + "\n"
        self.log.text = logText

        if locationService.startReceivingLocationChanges(onLocationUpdate: { (locationManager: CLLocationManager, locations: [CLLocation]) in
            var state = ""
            switch UIApplication.shared.applicationState {
                
            case .active:
                state = "ACTIVE"
            case .inactive:
                state = "INACTIVE"
            case .background:
                state = "BACKGROUND"
            }
            let dict = BackendService.updateLocationChange(locationManager: locationManager, locations: locations, applicationState: state)

            self.logText += "State: " + state + " Content:" + String(describing: dict)+"\n\n"
            
            switch UIApplication.shared.applicationState {
            case .active:
                DispatchQueue.main.async {
                    self.log.text = self.logText
                    if self.autoScroll.isOn {
                        self.scrollTextViewToBottom(textView: self.log)
                    }
                }
            case .inactive: break
            case .background: break
            }

        }) {
            self.isUpdating = true
        } else {
            self.isUpdating = false
        }
    }
    
    func stopTracking() {
        locationService.stopReceivingLocationChanges()
        
        self.log.text = self.log.text + "\n"
        
        self.isUpdating = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.log.text = self.logText

        if !self.isUpdating {
            self.requestAuthorisation(onWhenInUse: {
                
                let alert = UIAlertController(title: "Location updates", message: "For continous location updates please allow 'Always' access.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    self.startTracking()
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }, onAlways: {
                self.startTracking()
            }) {
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

