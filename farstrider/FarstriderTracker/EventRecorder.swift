//
//  EventRecorder.swift
//  farstrider
//
//  Created by Jonathon Rubin on 3/18/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import Foundation
import CoreLocation
import FarstriderNetwork 

class EventRecorder :NSObject {
    
    func recordLocation(location :CLLocationCoordinate2D) {
        NSLog("At \(location.latitude), \(location.longitude)")
        
        let connectionToService = NSXPCConnection(serviceName:  "ubiquit.us.farstrider-network-servce")
        connectionToService.remoteObjectInterface = NSXPCInterface(withProtocol: FarstriderNetworkControllerProtocol.self)
        connectionToService.resume()
                
        let network :FarstriderNetworkControllerProtocol = connectionToService.remoteObjectProxy as! FarstriderNetworkControllerProtocol
        network.addLocation(atTime: NSDate(), withLongitude: Float(location.longitude), andLatitude: Float(location.latitude)) {
            connectionToService.invalidate()
        }
    }
    
}
