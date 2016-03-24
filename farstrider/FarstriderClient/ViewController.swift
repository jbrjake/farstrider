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

extension ViewController :MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let location = annotation as? Location {
            
            let identifier = "Pin"
            var pinView :MKPinAnnotationView
            
            if let dequeuedAnnotation = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedAnnotation.annotation = location
                pinView = dequeuedAnnotation
            }
            else {
                pinView = MKPinAnnotationView(annotation: location, reuseIdentifier: identifier)
            }
            
            return pinView
        }
        else {
            // Someone's associating the wrong annotation type :/
            return nil
        }
        
    }
    
}
