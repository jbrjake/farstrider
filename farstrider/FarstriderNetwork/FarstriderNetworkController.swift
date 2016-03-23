//
//  FarstriderNetworkController.swift
//  farstrider
//
//  Created by Jonathon Rubin on 3/22/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import Foundation

public protocol FarstriderNetworkControllerProtocol {
    
    func 
    addLocation( 
        atTime timestamp :NSDate, 
        withLongitude lon :Float, 
        andLatitude lat :Float, 
        andCallback callback :(() -> Void) 
    )
    
    func 
    getLocations( 
        withCallback callback :((NSArray?)-> Void) 
    )
    
}

public class FarstriderNetworkController :FarstriderNetworkControllerProtocol {

    let baseURL = "http://api.briansmom.com/api/v1/"
    
    public func 
    addLocation( 
        atTime timestamp :NSDate, 
        withLongitude lon :Float, 
        andLatitude lat :Float, 
        andCallback callback :(()->Void) 
    ) {
        
        let jsonDict :[String:AnyObject] = [
            "timestamp" : timestamp.timeIntervalSince1970 * 1000, 
            "longitude" : lon, 
            "latitude"  : lat
        ]
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
        ]

        do {
            let postData = try NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingOptions())
            if let postURL = NSURL(string: baseURL + "location/add") {
                let request = NSMutableURLRequest(URL: postURL)
                request.HTTPMethod = "POST"
                let session = NSURLSession(configuration: config)
                
                let task = session.uploadTaskWithRequest(request, fromData: postData, completionHandler: { (data, response, err) -> Void in
                    callback()
                })
                task.resume()
            }
        }
        catch {
            print("\(error)")
        }
    }
    
    public func 
    getLocations( 
        withCallback callback :((NSArray?)->Void) 
    ) {
        if let getURL = NSURL(string: baseURL + "locations") {
            let request = NSURLRequest(URL: getURL)
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
                do {
                    if let 
                        data = data,
                        jsonArray = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray
                    {
                            callback(jsonArray)
                    }
                }
                catch {
                    print(error)
                }
            })
            
            task.resume()
        }
    }

}