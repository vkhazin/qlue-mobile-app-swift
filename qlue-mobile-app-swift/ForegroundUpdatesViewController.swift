//
//  FirstViewController.swift
//  qlue-mobile-app-swift
//
//  Created by Vlad Khazin on 2019-03-24.
//  Copyright © 2019 ICS Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class ForegroundUpdatesViewController: LocationUpdatesViewController {
    
    override func requestAuthorisation( onWhenInUse: (() -> Void)? = nil, onAlways: (() -> Void)? = nil, onDenial: (() -> Void)? = nil) {
        locationService.requestWhenInUseAuthorization( onWhenInUse: onWhenInUse, onAlways: onAlways, onDenial: onDenial)
    }
}
