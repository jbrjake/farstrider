//
//  SensorController.swift
//  farstrider
//
//  Created by Jonathon Rubin on 3/18/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import Foundation
import Cocoa

@objc enum SensorEventType :Int {
    case Woke // As in, from power sleep
}

// The delegate is notified when an event occurs.
// This can be used as a cue for when to retrieve and log the device location.
@objc protocol SensorControllerDelegate {
    func eventSensed(eventType :SensorEventType)
}

class SensorController :NSObject {
    
    var delegate :SensorControllerDelegate?
    
    override init() {
        super.init()
        
        // Observe when the device wakes from sleep
        NSWorkspace.sharedWorkspace()
        .notificationCenter
        .addObserver(
            self, 
            selector: "woke:", 
            name: NSWorkspaceDidWakeNotification, 
            object: nil
        )
    }
    
    // Trigger an event when the machine wakes up
    func woke(note :NSNotification) {
        NSLog("machine woke up")
        self.delegate?.eventSensed(.Woke)
    }
    
}
