//
//  SessionController.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import SwiftUI


// This class will handle the most that has to controlling getting the session data

/// Control every session
class SessionController: ObservableObject{
    
    @Published var currentSession:Session!
    var eventTimer:Timer?
    var sessionSplitter:SessionSplitter = SessionSplitter()
    
    init() {
        
    }
    
    /**
    This function starts a new session.
     
    - Returns: A new Session instance.
    */
    func startSession(wakeUpTime:Date) -> Session{
        print("Will start the session")
        
        let SESSION_UUID = UUID()
        let sensorList = SessionConfig.getSensorList(SESSION_UUID: SESSION_UUID)
        
        currentSession = Session(wakeUpTime: wakeUpTime, sensorList: sensorList, sessionIdentifier: SESSION_UUID)
        currentSession.startSession()
        // Fire the timer, so that events will be processes batchwise.
        self.eventTimer = Timer.scheduledTimer(withTimeInterval: SessionConfig.BATCHFREQUENCY, repeats: true) {_ in
            self.handleBatch()
        }

        return currentSession!
    }
        
    /**
        Will call the session object and end the current session. If currentsession has already ended, it will do nothing.
     */
    func endSession(){
        if self.eventTimer != nil {
          self.eventTimer?.invalidate()
          self.eventTimer = nil
        }
        
        if(self.currentSession?.hasEnded == false){
            let didEnd = self.currentSession?.endSession()
            self.currentSession?.hasEnded = didEnd ?? false
        }
        self.handleBatch()
    }
    
    func handleBatch(){
        let events = self.splitSessionEvents()
        self.runSinks(events: events)
        self.currentSession!.updateHandledEventsCount(uploadedEvents: events.count)
    }
    
    /**
     This method should be called at an interval during a session.
     It collects events that the sensors has gathered until this point.
     */
    func splitSessionEvents() -> [Data]{
        print("@Func-splitSession in SessionController")
        let splittedArray = sessionSplitter.splitSession(session: self.currentSession)
        return splittedArray
    }
    
    func runSinks(events:[Data]) {
        print("@Func-runSink in SessionController")
        //        let events1 = CloudKitSink.runSink(events: events, sessionIdentifier: self.currentSession?.sessionIdentifier.description ?? "NA")
        //        let _ = ConsoleSink.runSink(events: events1, sessionIdentifier: self.currentSession?.sessionIdentifier.description ?? "NA")
        let sensorsToRemove:[String] = []
//        let mutatedEvents = FilterSink.runSink(events: events, sensorsToRemove: sensorsToRemove)
        let mutatedEvents = AggregationSink.runSink(events: events, sessionIdentifier: self.currentSession?.sessionIdentifier.description ?? "NA")
        let _ = ConsoleSink.runSink(events: mutatedEvents)
    }
    
    /**
    Function for getting the duration of the session. If the session is ongoing the returned value reflects the current duration.

    - Parameter session: The session we are interested in
     
    - Returns: Will return the duration of the session as a `String`.
    */
    func getSessionDurationString(session:Session) -> String {
        let toTime = session.end_time ?? Date()
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar
            .dateComponents([.day, .hour, .minute, .second],
                            from: session.start_time,
                            to: toTime)
        return String(format: "%02dh:%02dm:%02ds", components.hour ?? 00, components.minute ?? 00, components.second ?? 00)
    }

    /**
     Will return the number of events gathered by the session
     */
    func getNumberOfEvents() -> Int{
        return self.currentSession?.getNumberOfEvents() ?? 0
    }
    
    #if os(iOS)
    #else
    func getLatestBatteryWatchEvent() -> String{
        return currentSession!.getLatestBatteryWatchEvent().getPercent().description + "%"
    }
    
    func getLatestHeartRateData() -> String{
        return currentSession!.getLatestHREvent()?.getHR().description ?? "---"
    }
    #endif
}
