//
//  Config.swift
//  qlue-mobile-app-swift
//
//  Created by vedran on 27/03/2019.
//  Copyright © 2019 ICS Solutions. All rights reserved.
//

import Foundation
import CoreLocation

class Config {

    static let isProduction = true
    
    class Development {

        class LocationUpdates {
            static let desiredAccuracy: Double = 1 // meters
        }
        class Backend {
            static let url = "https://postman-echo.com/post"
        }

    }
    
    class Production {
        
        class LocationUpdates {
            static let desiredAccuracy: Double = 500 // meters
        }
        class Backend {
            static let url = "https://gsqztydwpe.execute-api.us-east-1.amazonaws.com/latest"
        }

    }
}
