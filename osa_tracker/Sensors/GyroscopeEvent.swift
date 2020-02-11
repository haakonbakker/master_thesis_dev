//
//  GyroscopeEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

struct GyroscopeEvent: EventProtocol{
    var sessionIdentifier: String
    
    var sensorName: String
    
    var timestamp:UInt64
    private var event:EventData
    
    private struct EventData:Codable{
        var x:Double
        var y:Double
        var z:Double
    }
    
    init(x:Double, y:Double, z:Double, timestamp:Date, sessionIdentifier:String){
        self.event = EventData(x: x, y: y, z: z)
        self.timestamp = UInt64(timestamp.timeIntervalSince1970 * 1000.0)
        self.sensorName = "Gyroscope"
        self.sessionIdentifier = sessionIdentifier
    }
}
