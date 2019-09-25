//
//  AccelerometerEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 25/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
struct AccelerometerEvent:EventProtocol{
    var sensorName: String
    var timestamp: Date
    
    private var event:EventData
    
    private struct EventData:Codable{
        var x:Double
        var y:Double
        var z:Double
    }
    
    init(x:Double, y:Double, z:Double, timestamp:Date){
        self.event = EventData(x: x, y: y, z: z)
        self.timestamp = timestamp
        self.sensorName = "Accelerometer"
    }
}
