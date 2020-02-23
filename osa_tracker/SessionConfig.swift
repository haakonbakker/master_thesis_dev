//
//  SessionConfig.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 31/12/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation


class SessionConfig{
    
    static let BATCHFREQUENCY:Double = 5
    
    init() {
        
    }
    
    static func getSensorList(SESSION_UUID:UUID) -> [Sensor]{
        #if os(iOS)
        let sensorList = [
                GyroscopeSensor(sessionIdentifier: SESSION_UUID),
                MicrophoneSensor(sessionIdentifier: SESSION_UUID),
                BatterySensor(samplingRate: 5, sessionIdentifier: SESSION_UUID),
                MetaSensor(sessionIdentifier: SESSION_UUID)
            ]
        #else
        let sensorList = [
                GyroscopeSensor(sessionIdentifier: SESSION_UUID),
                AccelerometerSensor(sessionIdentifier: SESSION_UUID),
                BatterySensorWatch(samplingRate: 5, sessionIdentifier: SESSION_UUID),
                HeartRateSensor(sessionIdentifier: SESSION_UUID),
                MetaSensor(sessionIdentifier: SESSION_UUID)
            ]
        #endif
        
        return sensorList
    }
    
    static func runSinks(events:[Data], UUID:String)
    {
        let _ = CloudKitSink.runSink(events: events, sessionIdentifier: UUID)
//        let _ = SplunkSink.runSink(events: events)
    }
}
