//
//  BatteryEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 19/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import UIKit


class BatteryEvent:EventProtocol, Codable {
    
    private struct EventData:Codable{
        var batteryLevel:Float
        var batteryPercent:Float
        var batteryState:Int
    }
    
    var sensorName: String
    var timestamp: Date
    var device:String
    private var event:EventData
    
    
    init(device:String, batteryLevel:Float, batteryState:Int) {
        self.device = device
        self.timestamp = Date()
        self.sensorName = "Battery"
        self.event = EventData(batteryLevel: batteryLevel, batteryPercent: batteryLevel*100, batteryState: batteryState)
    }
}
