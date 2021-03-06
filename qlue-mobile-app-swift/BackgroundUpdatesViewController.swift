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
    
    override func requestAuthorisation( onWhenInUse: (() -> Void)? = nil, onAlways: (() -> Void)? = nil, onDenial: (() -> Void)? = nil) {
        locationService.requestAlwaysAuthorization( onWhenInUse: onWhenInUse, onAlways: onAlways, onDenial: onDenial)
    }    

    override func startTracking() {
        locationService.locationManager.allowsBackgroundLocationUpdates = true
        locationService.locationManager.pausesLocationUpdatesAutomatically = false
        locationService.locationManager.showsBackgroundLocationIndicator = true
        
        super.startTracking()
        
    }
}
