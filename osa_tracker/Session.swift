//
//  Session.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class Session:Identifiable{
    var id:Int
    var timestamp:String
    var duration:String
    var start_time:Date
    var end_time:Date?
    var hasEnded:Bool
    var wakeUpTime:Date
    var sensorList:[Sensor]
    
    init(id:Int, wakeUpTime:Date, sensorList:[Sensor]){
        self.id = id
        self.duration = "6h23m"
        self.timestamp = "June 9th to June 10th"
        self.start_time = Date()
        self.end_time = Date()
        self.hasEnded = false
        self.sensorList = sensorList
        self.wakeUpTime = wakeUpTime
    }

    // Start the session here
    func startSession() -> Bool{
        self.start_time = Date()
        return true
    }
    
    // End the session here
    func endSession() -> Bool{
        self.end_time = Date()
        return true
    }
    
    func getWakeUpTime() -> Date {
        return self.wakeUpTime
    }
    
    
}
