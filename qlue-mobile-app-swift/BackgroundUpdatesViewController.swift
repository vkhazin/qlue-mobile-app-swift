//
//  SecondViewController.swift
//  qlue-mobile-app-swift
//
//  Created by Vlad Khazin on 2019-03-24.
//  Copyright © 2019 ICS Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class BackgroundUpdatesViewController: LocationUpdatesViewController {

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if !self.isUpdating {
//
//            self.requestAuthorisation(onWhenInUse: {
//                self.start.isEnabled = false
//                self.stop.isEnabled = false
//            }, onAlways: {
//                self.start.isEnabled = true
//                self.stop.isEnabled = false
//            }) {
//                self.start.isEnabled = false
//                self.stop.isEnabled = false
//            }
//        }
//    }

//    @IBAction func didPressStart(_ sender: Any) {
//
//        self.log.text = self.log.text + String(describing: NSDate()) + "\n"
//
//        if locationService.startReceivingLocationChanges(onLocationUpdate: { (locations: [CLLocation]) in
//
//            if let locations_last = locations.last {
//                self.log.text = self.log.text + "(" + String(describing: locations_last.coordinate.latitude)+String(describing: locations_last.coordinate.longitude)+")\n"
//
//                self.scrollTextViewToBottom(textView: self.log)
//            }
//        }) {
//            self.isUpdating = true
//
//            self.start.isEnabled = false
//            self.stop.isEnabled = true
//        } else {
//            self.isUpdating = false
//
//            self.start.isEnabled = true
//            self.stop.isEnabled = false
//        }
//    }
//
//    @IBAction func didPressStop(_ sender: Any) {
//        locationService.stopReceivingLocationChanges()
//
//        self.log.text = self.log.text + "\n"
//
//        self.isUpdating = false
//        self.start.isEnabled = true
//        self.stop.isEnabled = false
//    }
    
    override func requestAuthorisation( onWhenInUse: (() -> Void)? = nil, onAlways: (() -> Void)? = nil, onDenial: (() -> Void)? = nil) {
        locationService.requestAlwaysAuthorization( onWhenInUse: onWhenInUse, onAlways: onAlways, onDenial: onDenial)
    }    

}
