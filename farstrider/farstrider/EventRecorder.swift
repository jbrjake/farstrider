//
//  EventRecorder.swift
//  farstrider
//
//  Created by Jonathon Rubin on 3/18/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import Foundation
import CoreLocation

class EventRecorder :NSObject {
    
    func recordLocation(location :CLLocationCoordinate2D) {
        NSLog("At \(location.latitude), \(location.longitude)")
    }
    
}
