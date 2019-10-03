//
//  HeartRateEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

struct HeartRateEvent:EventProtocol {
    var sensorName: String
    var timestamp: Date
    
    private var event:EventData
    
    private struct EventData:Codable{
        var unit:String
        var heartRate:Double
    }
    
    
    init(unit:String, heartRate:Double) {
        self.timestamp = Date()
        self.sensorName = "Heart Rate"
        self.event = EventData(unit: unit, heartRate: heartRate)
    }
    
    func getHR() -> Double{
        return event.heartRate
    }
    
    func getHRUnit() -> String{
        return event.unit
    }
}
