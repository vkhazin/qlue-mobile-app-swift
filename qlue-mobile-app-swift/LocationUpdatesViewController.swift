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
    
    let locationService = LocationService()
    
    var isUpdating = false
    
    @IBAction func didPressStart(_ sender: Any) {
        
        self.log.text = self.log.text + String(describing: NSDate()) + "\n"
        
        if locationService.startReceivingLocationChanges(onLocationUpdate: { (locationManager: CLLocationManager, locations: [CLLocation]) in
            let dict = BackendService.updateLocationChange(locationManager: locationManager, locations: locations)
            
            self.log.text = self.log.text + String(describing: dict)+"\n\n"
            
            self.scrollTextViewToBottom(textView: self.log)

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

