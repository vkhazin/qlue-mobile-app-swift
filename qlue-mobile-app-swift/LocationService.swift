//
//  LocationService.swift
//  qlue-mobile-app-swift
//
//  Created by vedran on 26/03/2019.
//  Copyright © 2019 ICS Solutions. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var onWhenInUse: (() -> Void)? = nil
    var onAlways: (() -> Void)? = nil
    var onDenial: (() -> Void)? = nil
    
    var onLocationUpdate: ((CLLocationManager, [CLLocation]) -> Void)? = nil
}

// request permissions

extension LocationService {
    
    func requestWhenInUseAuthorization( onWhenInUse: (() -> Void)? = nil, onAlways: (() -> Void)? = nil, onDenial: (() -> Void)? = nil) {
        requestAuthorization(always: false, onWhenInUse: onWhenInUse, onAlways: onAlways, onDenial: onDenial)
    }

    func requestAlwaysAuthorization( onWhenInUse: (() -> Void)? = nil, onAlways: (() -> Void)? = nil, onDenial: (() -> Void)? = nil) {
        requestAuthorization(always: true, onWhenInUse: onWhenInUse, onAlways: onAlways, onDenial: onDenial)
    }

    private func requestAuthorization(always: Bool, onWhenInUse: (() -> Void)?, onAlways: (() -> Void)?, onDenial: (() -> Void)?) {

        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            
            self.onWhenInUse = onWhenInUse
            self.onAlways = onAlways
            self.onDenial = onDenial

            // Request when-in-use authorization initially
            if always {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
            break
            
        case .restricted, .denied:
            // Disable location features
            onDenial?()
            break
            
        case .authorizedWhenInUse:
            // Enable basic location features
            
            if always {
                
                self.onWhenInUse = onWhenInUse
                self.onAlways = onAlways
                self.onDenial = onDenial
                
                locationManager.requestAlwaysAuthorization()
            }

            break
            
        case .authorizedAlways:
            // Enable any of your app's location features
            onAlways?()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted, .denied:
            // Disable your app's location features
            onDenial?()
            break
        
        case .authorizedWhenInUse:
            // Enable only your app's when-in-use features.
            onWhenInUse?()
            break
        
        case .authorizedAlways:
            // Enable any of your app's location services.
            onAlways?()
            break
        
        case .notDetermined:
            break
            }
    }
    
}

// manage location updates

extension LocationService {
    
    func startReceivingLocationChanges(onLocationUpdate: @escaping ((CLLocationManager, [CLLocation]) -> Void)) -> Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return false
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return false
        }
        
        self.onLocationUpdate = onLocationUpdate
        
        // Configure and start the service.
        locationManager.distanceFilter = Config.isProduction ? Config.Production.LocationUpdates.desiredAccuracy : Config.Development.LocationUpdates.desiredAccuracy
        locationManager.desiredAccuracy = Config.isProduction ? Config.Production.LocationUpdates.desiredAccuracy : Config.Development.LocationUpdates.desiredAccuracy
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        return true
    }

    func stopReceivingLocationChanges() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        onLocationUpdate?( manager, locations)
    }
}
