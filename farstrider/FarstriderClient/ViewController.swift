//
//  ViewController.swift
//  FarstriderClient
//
//  Created by Jonathon Rubin on 3/24/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import UIKit
import FarstriderNetwork

class ViewController: UIViewController {

    var locations = LocationController(withNetwork: FarstriderNetworkController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        self.refreshData()
    }
    
    func refreshData() {
        self.locations.loadLocations { () -> Void in
            self.redisplayPins()
        }        
    }
    
    func redisplayPins() {
        
    }
    
}

