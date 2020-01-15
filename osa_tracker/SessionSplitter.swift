//
//  SessionSplitter.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 13/11/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class SessionSplitter{
    init(){
    }
    
    /**
     Will split the events from the sensors.
     Takes the oldest events until the time when this method is called.
     */
    func splitSession(session:Session) -> [Data]{
        print("@Func-splitSession in SessionSplitter")
        
        let eventCount = session.eventList.count - 1 // Index starts at 0
        let splittedEvents = Array(session.eventList[0...eventCount - 1]) // Remove all but last.
        
        // Update the eventList to only contain the last event
        session.eventList = Array(session.eventList[eventCount...session.eventList.count - 1])
        
        return splittedEvents
    }
}
