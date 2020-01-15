//
//  Session.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class Session:Identifiable{
    var timestamp:String
    var duration:String
    var start_time:Date
    var end_time:Date?
    var hasEnded:Bool
    var wakeUpTime:Date
    var sensorList:[Sensor]
    var sensorDict:Dictionary<SensorEnumeration, [Sensor]>
    var sessionIdentifier:UUID
    var eventList:[Data]
    var handledEvents:Int
    
    
    init(wakeUpTime:Date, sensorList:[Sensor], sessionIdentifier:UUID){
        self.duration = "6h23m"
        self.timestamp = "June 9th to June 10th"
        self.start_time = Date()
        self.end_time = Date()
        self.hasEnded = false
        self.sessionIdentifier = sessionIdentifier
        print(self.sessionIdentifier)
        self.sensorList = sensorList
        self.wakeUpTime = wakeUpTime
        self.sensorDict = Dictionary(grouping: self.sensorList, by: {$0.sensorName})
        print("Sensor dict: \n\t\(self.sensorDict)")
        self.handledEvents = 0
        self.eventList = []
    }

    // Start the session here
    func startSession(){
        _ = self.startSensors()
        self.start_time = Date()
    }
    
    // End the session here
    func endSession() -> Bool{
        _ = self.stopSensors()
        self.end_time = Date()
        return true
    }
    
    /**
     Will get the session's wake up time
     */
    func getWakeUpTime() -> Date {
        return self.wakeUpTime
    }
    
    #if os(watchOS)
    func getLatestBatteryWatchEvent() -> BatteryEvent{
        let batterySensor = self.sensorDict[.BatterySensorWatch]![0] as! BatterySensorWatch
        return batterySensor.getLastEvent()
        
    }
    
    func getLatestHREvent() -> HeartRateEvent?{
        if(self.sensorDict[.HeartRateSensor] != nil){
            let heartRateSensor = self.sensorDict[.HeartRateSensor]![0] as! HeartRateSensor
            return heartRateSensor.getLastEvent()
        }else{
            return nil
        }
    }
    #endif
    
    
    /**
     Will stop all the sensors in the sensorList.
     */
    func stopSensors() -> Bool {        
        for sensor in self.sensorList{
            _ = sensor.stopSensor()
        }
        return true
    }
    
    /**
    Will start all the sensors in the sensorList.
     */
    func startSensors() -> Bool {
        for sensor in self.sensorList{
            _ = sensor.startSensor(session:self)
        }
        return true
    }
    
    
    /**
     Will return the number of events gathered by all the sensors combined
     
     - Returns: The number of events as `Int`.
     */
    func getNumberOfEvents() -> Int {
        return self.eventList.count + self.handledEvents
    }
    
    func updateHandledEventsCount(uploadedEvents:Int) {
        self.handledEvents += uploadedEvents
    }
}
