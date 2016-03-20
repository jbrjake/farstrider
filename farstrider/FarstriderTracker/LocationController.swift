//
//  LocationController.swift
//  farstrider
//
//  Created by Jonathon Rubin on 3/18/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController :NSObject {

    let locationManager = CLLocationManager()
    let eventRecorder = EventRecorder()
    
    var currentPosition :CLLocationCoordinate2D? {
        didSet { 
            // When the position changes, log it in the Event recorder and then
            // revert to looking for significant changes in order to save battery
            if let position = currentPosition {
                self.eventRecorder.recordLocation(position)
                locationManager.stopUpdatingLocation()
                locationManager.startMonitoringSignificantLocationChanges()
            }
        }
    }
    
    override init() {
        super.init()

        let locationOn = CLLocationManager.locationServicesEnabled()
        NSLog("location services enabled: \(locationOn)")

        locationManager.delegate = self
        
        // Grab initial location
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationController :CLLocationManagerDelegate {

    // Set the new position
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        if let location = locations.last as? CLLocation {
            self.currentPosition = location.coordinate
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("error: \(error)")
    }
}


extension LocationController :SensorControllerDelegate {
    
    // When a sensor event comes through, flip on power-hungry location updating until
    // we obtain a new location. Afterwards the didSet on self.currentPosition will turn it off again.
    func eventSensed(eventType: SensorEventType) {
        locationManager.startUpdatingLocation()
    }
}