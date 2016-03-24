//
//  LocationController.swift
//  farstrider
//
//  Created by Jonathon Rubin on 3/24/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import Foundation
import FarstriderNetwork
import CoreLocation

struct Location {
    let date :NSDate
    let coordinates :CLLocationCoordinate2D
}

class LocationController {
    
    let network :FarstriderNetworkControllerProtocol
    let formatter = NSDateFormatter()

    var locations = [Location]()
    
    
    init(withNetwork network :FarstriderNetworkControllerProtocol) {
        self.network = network
        self.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
    
    func loadLocations(withCallback callback :(()->Void) ) {
        network.getLocations { (rawLocations) -> Void in
            if let rawLocations = rawLocations {
                self.parseRawLocations(rawLocations)
            }
            callback()
        }
    }
    
    private func parseRawLocations(rawLocations :NSArray) {
        locations.removeAll()
        
        for rawLocation in rawLocations {
            guard let
                rawLocation = rawLocation as? NSDictionary,
                rawTime     = rawLocation["timestamp"] as? String,
                date        = self.formatter.dateFromString(rawTime),
                rawLat      = rawLocation["latitude"] as? CLLocationDegrees,
                rawLon      = rawLocation["longitude"] as? CLLocationDegrees
            else {
                continue
            }
            
            let coordinates = CLLocationCoordinate2D(latitude: rawLat, longitude: rawLon)
            
            let location = Location(date: date, coordinates: coordinates)
            self.locations.append(location)
        }
        
        locations.sortInPlace { (location1, location2) -> Bool in
            return location1.date.compare(location2.date) == NSComparisonResult.OrderedAscending
        }
    }
    
}