//
//  FarstriderNetworkTests.swift
//  FarstriderNetworkTests
//
//  Created by Jonathon Rubin on 3/22/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

import XCTest
@testable import FarstriderNetwork

class FarstriderNetworkTests: XCTestCase {
    
    let network = FarstriderNetworkController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddAndGetLocation() {
        let addExpectation = self.expectationWithDescription("Adding a location completes")
        
        let timestamp = NSDate()
        let lon = Float(150.0)
        let lat = Float(100.0)
        network.addLocation(
            atTime: timestamp, 
            withLongitude: lon, 
            andLatitude: lat) 
        { 
            addExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
        
        let getExpectation = self.expectationWithDescription("Locations are returned")
        
        network.getLocations() { locations in            
            XCTAssertNotNil(
                locations, 
                "The location array should exist.");
            
            XCTAssertNotEqual(
                locations?.count, 
                0, 
                "There should be at least one location.")
            
            let item = locations?.lastObject

            XCTAssertNotNil(
                item as? NSDictionary, 
                "The item should be an NSDictionary")
            
            if let location = item as? NSDictionary {
                
                XCTAssertNotNil(
                    location["timestamp"] as? String, 
                    "The location should contain a timestamp value");

                // And since now we know the timestamp exists and is a string, it's safe to...
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let returnedTimestamp = formatter.dateFromString(location["timestamp"] as! String)
                
                XCTAssertNotNil(
                    location["latitude"] as? Float, 
                    "The location should contain a latitude value");
               
                XCTAssertNotNil(
                    location["longitude"] as? Float, 
                    "The location should contain a longitude value");
                

                XCTAssertEqual(
                    Int64((returnedTimestamp?.timeIntervalSince1970)! * 1000), 
                    Int64(timestamp.timeIntervalSince1970 * 1000), 
                    "The location timestamp should be the same as the one we just added, give or take a few ms")
                
                XCTAssertEqual(
                    location["latitude"] as? Float, 
                    lat, 
                    "The latitude should be the same as the one we just added")
                
                XCTAssertEqual(
                    location["longitude"] as? Float, 
                    lon, 
                    "The longitude should be the same as the one we just added.")
            }
            
            getExpectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(10, handler: nil)

    }
    
}
