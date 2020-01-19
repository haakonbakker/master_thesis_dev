//
//  MetaSensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 19/01/2020.
//  Copyright © 2020 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

// Special kind of sensor.
// Will be called from the SessionController
class MetaSensor:Sensor, SensorInterface{
    
    override init(sensorEnum: SensorEnumeration = .MetaSensor, sessionIdentifier:UUID) {
        super.init(sensorEnum: sensorEnum, sessionIdentifier:sessionIdentifier)
    }
    
    func collectEvent() {
    
    }
    
    override func startSensor(session:Session) -> Bool {
        currentSession = session
        // Create metaStartEvent
        // Push to the session.eventlist
        let event = MetaStartEvent(sensorList: SessionConfig.getSensorList(SESSION_UUID: currentSession?.sessionIdentifier ?? UUID()), sessionIdentifier: currentSession?.sessionIdentifier.description ?? UUID().description)
        currentSession?.eventList.append(encodeEvent(event: event)!)
        return true
    }
    
    override func stopSensor() -> Bool {
        // Create metaStartEvent
        // Push to the session.eventlist
        let event = MetaStopEvent(sessionIdentifier: currentSession?.sessionIdentifier.description ?? UUID().description, totalCount: currentSession?.getNumberOfEvents() ?? 0)
        currentSession?.eventList.append(encodeEvent(event: event)!)
        currentSession?.eventList.append(encodeEvent(event: event)!) // Fix this. This is due to how the session is split, the last event will not be splitted. 
        return true
    }
    
    func encodeEvent(event:MetaStartEvent) -> Data?{
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            let res = try encoder.encode(event)
            return res
        }catch{
            print(error)
        }
        return nil
    }
    
    func encodeEvent(event:MetaStopEvent) -> Data?{
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            let res = try encoder.encode(event)
            return res
        }catch{
            print(error)
        }
        return nil
    }
}
