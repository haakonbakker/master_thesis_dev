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
    var sensorDict:Dictionary<SensorEnumeration, [Sensor]>
    var sessionIdentifier:UUID
    
    
    init(id:Int, wakeUpTime:Date, sensorList:[Sensor], sessionIdentifier:UUID){
        self.id = id
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
        print(self.sensorDict)
        print("****************")
    }

    // Start the session here
    func startSession() -> Bool{
        self.startSensors()
        self.start_time = Date()
        return true
    }
    
    // End the session here
    func endSession() -> Bool{
        self.stopSensors()
        self.end_time = Date()
        return true
    }
    
    func getWakeUpTime() -> Date {
        return self.wakeUpTime
    }
    
//    func getLatestEvent(sensor_enum:SensorEnumeration) -> Any?{
////        print("Sensor_enum: ", sensor_enum)
////        for sensor in self.sensorList{
////            print("Type of sensor: ", type(of: sensor))
////            if (type(of:sensor.sensorName) == type(of: sensor_enum))  {
////                print("The sensor is a match!")
////            }
//////
////            if case .sensor_enum.self = sensor.sensorName{
////                print("Battery sensor")
////            }
////        }
//
//        for sensor in self.sensorDict{
//            print(sensor.key)
//            print(sensor_enum)
//            if(sensor_enum == sensor.key){
//                print("Match on: ")
//                print(sensor.key)
//                print(sensor_enum)
//            }
//        }
//        return nil
//    }
    
//    func getSensor(type:Sensor) -> Sensor{
//        for sensor in self.sensorList{
//            if(type(of: sensor) == type(of:type)){
//                return sensor
//            }
//        }
//    }
    
    func getLatestBatteryWatchEvent() -> BatteryEvent{
        var batterySensor = self.sensorDict[.BatterySensorWatch]![0] as! BatterySensorWatch
        return batterySensor.getLastEvent()
        
    }
    
    #if os(watchOS)
    func getLatestHREvent() -> HeartRateEvent?{
        var heartRateSensor = self.sensorDict[.HeartRateSensor]![0] as! HeartRateSensor
        return heartRateSensor.getLastEvent()
    }
    #endif
    
    
    /**
     Will stop all the sensors in the sensorList.
     */
    func stopSensors() -> Bool {        
        for sensor in self.sensorList{
            sensor.stopSensor()
        }
        return true
    }
    
    /**
    Will start all the sensors in the sensorList.
     */
    func startSensors() -> Bool {
        for sensor in self.sensorList{
            sensor.startSensor()
        }
        return true
    }
    
    
    /**
     Will return the number of events gathered by all the sensors combined
     
     - Returns: The number of events as `Int`.
     */
    func getNumberOfEvents() -> Int {
        var numberOfEvents = 0
        
        for sensor in self.sensorList {
            numberOfEvents += sensor.getNumberOfEvents()
        }

        return numberOfEvents
    }
}
