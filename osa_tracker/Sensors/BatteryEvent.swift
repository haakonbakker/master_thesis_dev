//
//  BatteryEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 19/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import UIKit

struct BatteryEvent:Event {
    var timestamp: Date
    var device:String
    var batteryLevel:Float
    var batteryPercent:Float
    var batteryState:Int
    
    init(device:String, batteryLevel:Float, batteryState:UIDevice.BatteryState.RawValue) {
        self.device = device
        self.batteryLevel = batteryLevel
        self.batteryPercent = batteryLevel*100
        self.batteryState = batteryState
        self.timestamp = Date()
    }
}
