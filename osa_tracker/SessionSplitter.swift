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
    func splitSession(date:Date) -> [Data]{
        print("@Func-splitSession in SessionSplitter")
//        print("********", session.sessionIdentifier)
//        for sensor in session.sensorList{
//            self._getSplitEventsFromSensor(sensor: sensor, date: date)
//        }
        print("Data about the current eventList:")
        let evlistCount = self.session.eventList.count
        print("\tCount: \(evlistCount)")
        print("\tCapacity: \(self.session.eventList.capacity)")
        
        let eventCount = self.session.eventList.count - 1 // Index starts at 0
        let splittedEvents = Array(self.session.eventList[0...eventCount - 1]) // Remove all but last.
        
        // Update the eventList to only contain the last event
        self.session.eventList = Array(self.session.eventList[eventCount...self.session.eventList.count - 1])
        
        let newEvListCount = self.session.eventList.count
        print("\tsplittedEvents: Count: \(splittedEvents.count)")
        print("\teventList: Count: \(newEvListCount)")
        print("\tTotal Events: \(splittedEvents.count + newEvListCount) - Should be: \(evlistCount)")
        
        return splittedEvents
    }
    
    
    
}
