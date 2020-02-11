//
//  BatteryEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 19/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import UIKit


class BatteryEvent:EventProtocol {
    
    private struct EventData:Codable{
        var batteryLevel:Float
        var batteryPercent:Float
        var batteryState:Int
    }
    
    var sensorName: String
    var timestamp: UInt64
    var device:String
    var sessionIdentifier:String
    private var event:EventData
    
    init(device:String, batteryLevel:Float, batteryState:Int) {
        self.device = device
        self.timestamp = UInt64(NSDate().timeIntervalSince1970 * 1000.0)
        self.sensorName = "Battery"
        self.event = EventData(batteryLevel: batteryLevel, batteryPercent: batteryLevel*100, batteryState: batteryState)
        self.sessionIdentifier = "NA"
    }
    init(device:String, batteryLevel:Float, batteryState:Int, sessionIdentifier:String?) {
        self.device = device
        self.timestamp = UInt64(NSDate().timeIntervalSince1970 * 1000.0)
        self.sensorName = "Battery"
        self.event = EventData(batteryLevel: batteryLevel, batteryPercent: batteryLevel*100, batteryState: batteryState)
        self.sessionIdentifier = sessionIdentifier ?? "NA"
    }
    
    func getPercent() -> Float{
        return self.event.batteryPercent
    }
}
