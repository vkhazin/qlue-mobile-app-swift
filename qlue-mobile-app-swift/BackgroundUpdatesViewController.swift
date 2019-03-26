//
//  SecondViewController.swift
//  qlue-mobile-app-swift
//
//  Created by Vlad Khazin on 2019-03-24.
//  Copyright © 2019 ICS Solutions. All rights reserved.
//

import UIKit

class BackgroundUpdatesViewController: UIViewController {

    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var log: UITextView!

    let locationService = LocationService()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationService.requestAlwaysAuthorization(onWhenInUse: {
            self.start.isEnabled = false
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

    }
    
    @IBAction func didPressStop(_ sender: Any) {
    }
    

}
