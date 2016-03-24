//
//  ViewController.swift
//  FarstriderClient
//
//  Created by Jonathon Rubin on 3/24/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import UIKit
import MapKit
import FarstriderNetwork

class ViewController: UIViewController {

    var locations = LocationController(withNetwork: FarstriderNetworkController())
    
    @IBOutlet var mapView :MKMapView!
    @IBOutlet var refreshButton :UIButton!
    @IBOutlet var spinner :UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        self.refreshButton.addTarget(self, action: "refreshData", forControlEvents: .TouchUpInside)
        
        self.refreshData()
    }
    
    func refreshData() {
        self.refreshButton.enabled = false
        self.refreshButton.hidden = true
        self.spinner.startAnimating()
        
        self.locations.loadLocations { () -> Void in
            self.redisplayPins()
            
            self.refreshButton.enabled = true
            self.refreshButton.hidden = false
            self.spinner.stopAnimating()
        }
    }
    
    func redisplayPins() {
        
    }
    
}

