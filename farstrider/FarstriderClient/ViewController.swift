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
    }
    
    override func viewDidAppear(animated: Bool) {
        self.refreshData()
    }
    
    func refreshData() {
        self.refreshButton.enabled = false
        self.refreshButton.hidden = true
        self.spinner.startAnimating()
        
        self.mapView.removeAnnotations(self.locations.annotations())
        
        self.locations.loadLocations { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshButton.enabled = true
                self.refreshButton.hidden = false
                self.spinner.stopAnimating()
                
                self.redisplayPins()
            }
        }
    }
    
    // Display the pins, but put a delay between each one
    func redisplayPins() {
        
        let startTime = dispatch_time(DISPATCH_TIME_NOW, 0)
        var timeDelay = Int64(250000000) // 0.25 seconds

        for location in self.locations.annotations()  {
            let timeOffset = dispatch_time(startTime, timeDelay)
            
            dispatch_after(timeOffset, dispatch_get_main_queue(), { () -> Void in
                self.mapView.addAnnotation(location)
            })

            timeDelay += timeDelay
        }
    }
    
}

extension ViewController :MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let 
            location = annotation as? Location 
        else {
            // Someone's associating the wrong annotation type :/
            return nil
        }
        
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
    
}
