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
    var sampleTimer:Timer?
    var sessionSplitter:SessionSplitter = SessionSplitter()

    /**
    This function starts a new session.
     
    - Returns: A new Session instance.
    */
    func startSession(wakeUpTime:Date) -> Session{
        let SESSION_UUID = UUID()
        CloudKitSink.createSession(sessionIdentifier: SESSION_UUID.description)
        let sensorList = SessionConfig.getSensorList(SESSION_UUID: SESSION_UUID)
        
        currentSession = Session(wakeUpTime: wakeUpTime, sensorList: sensorList, sessionIdentifier: SESSION_UUID)
        
        let evCount = self.currentSession.getNumberOfEvents()
        
        
        currentSession.startSession()
        
        #if os(watchOS)
        let bt = self.currentSession.getLatestBatteryWatchEvent() as BatteryEvent
        let btD = Double(bt.getPercent())
        
        CloudKitSink.uploadAggregated(sessionIdentifier: self.currentSession.sessionIdentifier.description, eventCount: Int64(evCount), batteryLevel: btD)
        #else
        #endif
        
        setupBatchTimer(interval: SessionConfig.BATCHFREQUENCY)
        return currentSession
    }
        
    func setupBatchTimer(interval:Double){
        // Fire the timer, so that events will be processes batchwise.
        self.eventTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {_ in
            self.handleBatch()
        }
        
        self.sampleTimer = Timer.scheduledTimer(withTimeInterval: (60*5), repeats: true) {_ in
            let evCount = self.currentSession.getNumberOfEvents()
            #if os(watchOS)
            let bt = self.currentSession.getLatestBatteryWatchEvent() as BatteryEvent
            let btD = Double(bt.getPercent())
            
            CloudKitSink.uploadAggregated(sessionIdentifier: self.currentSession.sessionIdentifier.description, eventCount: Int64(evCount), batteryLevel: btD)
            #else
            #endif
        }
    }
    /**
        Will call the session object and end the current session. If currentsession has already ended, it will do nothing.
     */
    func endSession(){
        let evCount = self.currentSession.getNumberOfEvents()
        #if os(watchOS)
        let bt = self.currentSession.getLatestBatteryWatchEvent() as BatteryEvent
        let btD = Double(bt.getPercent())
        
        CloudKitSink.uploadAggregated(sessionIdentifier: self.currentSession.sessionIdentifier.description, eventCount: Int64(evCount), batteryLevel: btD)
        #else
        #endif
        
        if self.eventTimer != nil {
            self.eventTimer?.invalidate()
            self.eventTimer = nil
            self.sampleTimer?.invalidate()
            self.sampleTimer = nil
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
        SessionConfig.runSinks(events: events, UUID: self.currentSession.sessionIdentifier.description)
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
