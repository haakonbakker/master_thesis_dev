//
//  Sensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class Sensor: NSObject {
    var sensorName: SensorEnumeration
    var events:[Any]
    init(sensorEnum:SensorEnumeration = .Sensor) {
        self.sensorName = sensorEnum
        self.events = []
        
    }
    
    func getNumberOfEvents() -> Int{
        fatalError("Must Override")
    }
    
    /**
     Will start the sensor. It will collect data on a given interval.
    */
    func startSensor() -> Bool{
        fatalError("Must Override")
    }
    
    /**
     Will stop the sensor.
    */
    func stopSensor() -> Bool{
        fatalError("Must Override")
    }
    
    func exportEvent(){
        return
//        print("Type of event:")
//        print("\(type(of: event))")
//        do {
//           // data we are getting from network request
//            let encoder = JSONEncoder()
//            let res = try encoder.encode(event)
//            print(res)
//            if let json = String(data: res, encoding: .utf8) {
//              print("json", json)
//            }
//
//        } catch { print(error) }
    }
    
    func exportEvents() -> String{
        return "{\"info\":\"Must be overriden\", \"sensor\":\"\(self.sensorName)\"}\n"
    }
}
