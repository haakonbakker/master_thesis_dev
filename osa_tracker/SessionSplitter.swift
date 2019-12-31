//
//  SessionSplitter.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 13/11/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class SessionSplitter{
    var session:Session
    
    init(session:Session){
        self.session = session
    }
    
    /**
     Will split the events from the sensors.
     Takes the oldest events until the time when this method is called.
     */
    func splitSession(date:Date){
        print("@Func-splitSession in SessionSplitter")
//        print("********", session.sessionIdentifier)
//        for sensor in session.sensorList{
//            self._getSplitEventsFromSensor(sensor: sensor, date: date)
//        }
        print("Data about the current eventList:\n Count: \(self.session.eventList.count)")
    }
    
    /**
     This function will get events from a sensor.
     
     */
    func _getSplitEventsFromSensor(sensor:Sensor, date:Date){
        print(sensor.sensorName)
        if sensor.sensorName == SensorEnumeration.BatterySensorWatch{
            let data = sensor.getSplitEvents()
            print("*****")
            
            print(data)
            
            print("*****")
        }
    }
}
