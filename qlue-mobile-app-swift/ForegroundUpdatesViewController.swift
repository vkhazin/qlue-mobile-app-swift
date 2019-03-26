//
//  FirstViewController.swift
//  qlue-mobile-app-swift
//
//  Created by Vlad Khazin on 2019-03-24.
//  Copyright © 2019 ICS Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class ForegroundUpdatesViewController: UIViewController {

    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var log: UITextView!
    
    let locationService = LocationService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationService.requestWhenInUseAuthorization(onWhenInUse: {
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
    
    @IBAction func didPressStart(_ sender: Any) {

        if locationService.startReceivingLocationChanges(onLocationUpdate: { (locations: [CLLocation]) in
            if let locations_last = locations.last {
                self.log.text = self.log.text + "(" + String(describing: locations_last.coordinate.latitude)+String(describing: locations_last.coordinate.longitude)+")\n"
            }
        }) {
            self.start.isEnabled = false
            self.stop.isEnabled = true
        } else {
            self.start.isEnabled = false
            self.stop.isEnabled = false
        }
    }
    
    @IBAction func didPressStop(_ sender: Any) {
        locationService.stopReceivingLocationChanges()
        
        self.log.text = self.log.text + "\n"

        self.start.isEnabled = true
        self.stop.isEnabled = false
    }


}
