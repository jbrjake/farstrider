//
//  TrackerController.swift
//  farstrider
//
//  Created by Jonathon Rubin on 3/20/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import Foundation

// Responsible for managing the process of tracking the device's location:
// 1) Determining initial location
// 2) Sensing when to re-check location
// 3) Passing location events for recording
class TrackerController :NSObject {
    let locator = LocationController()
    let sensor = SensorController()
    
    override init() {
        super.init()
        
        sensor.delegate = locator
    }
}