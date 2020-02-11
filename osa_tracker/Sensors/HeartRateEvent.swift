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
    var timestamp: UInt64
    var sessionIdentifier:String
    
    private var event:EventData
    
    private struct EventData:Codable{
        var unit:String
        var heartRate:Double
    }
    
    
    init(unit:String, heartRate:Double) {
        self.timestamp = UInt64(NSDate().timeIntervalSince1970)
        self.sensorName = "Heart Rate"
        self.event = EventData(unit: unit, heartRate: heartRate)
        self.sessionIdentifier = "NA"
    }
    
    init(unit:String, heartRate:Double, sessionIdentifier:String) {
        self.timestamp = UInt64(NSDate().timeIntervalSince1970)
        self.sensorName = "Heart Rate"
        self.event = EventData(unit: unit, heartRate: heartRate)
        self.sessionIdentifier = sessionIdentifier
    }
    
    func getHR() -> Double{
        return event.heartRate
    }
    
    func getHRUnit() -> String{
        return event.unit
    }
}
