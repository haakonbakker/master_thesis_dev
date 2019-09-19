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
    
    init(sensorEnum:SensorEnumeration = .Sensor) {
        self.sensorName = sensorEnum
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
    
}
