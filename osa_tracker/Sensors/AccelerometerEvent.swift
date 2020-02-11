//
//  AccelerometerEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 25/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
struct AccelerometerEvent:EventProtocol{
    var sessionIdentifier: String
    var sensorName: String
    var timestamp: UInt64
    private var event:EventData
    
    private struct EventData:Codable{
        var x:Double
        var y:Double
        var z:Double
    }
    
    init(x:Double, y:Double, z:Double, timestamp:NSDate, sessionIdentifier:String){
        self.event = EventData(x: x, y: y, z: z)
        self.timestamp = UInt64(timestamp.timeIntervalSince1970)
        self.sensorName = "Accelerometer"
        self.sessionIdentifier = sessionIdentifier
    }
}
