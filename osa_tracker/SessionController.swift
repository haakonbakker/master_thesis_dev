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
    var sessionSplitter:SessionSplitter?
    
    init() {

    }
    
    func getSessions() -> [Session]{
        let sessions:[Session] = []
        return sessions
    }
    
    /**
    This function starts a new session.

    - Returns: A new Session instance.
    */
    func startSession(wakeUpTime:Date) -> Session{
        let SESSION_UUID = UUID()
        let sensorList = SessionConfig.getSensorList(SESSION_UUID: SESSION_UUID)
        
        
        print("Will start the session")
        currentSession = Session(wakeUpTime: wakeUpTime, sensorList: sensorList, sessionIdentifier: SESSION_UUID)
                
        currentSession.startSession()
        self.sessionSplitter = SessionSplitter(session: self.currentSession!)
        
        // Fire the timer, so that events will be processes batchwise.
        self.eventTimer = Timer.scheduledTimer(withTimeInterval: SessionConfig.BATCHFREQUENCY, repeats: true) {_ in
            self.handleBatch()
        }

        return currentSession!
    }
    

    
    /**
        Will call the session object and end the current session.
     */
    func endSession(){
        if self.eventTimer != nil {
          self.eventTimer?.invalidate()
          self.eventTimer = nil
        }
        
        if(self.currentSession?.hasEnded == false){
            let didEnd = self.currentSession?.endSession()
            self.currentSession?.hasEnded = didEnd ?? false
        }else{
            // Session already ended
        }
    }
    
    func handleBatch(){
        let numberOfEvents = self.getNumberOfEvents()
        print("Number of events: ", numberOfEvents)
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
        
        guard self.currentSession != nil else {
            print("\tNo active currentSession")
            fatalError("\tcurrentSession is nil - cannot handle")
        }
        
        guard let sessionSplitter = self.sessionSplitter else {
            print("\tNo active sessionSplitter")
            fatalError("\tsessionSplitter is nil - cannot handle")
        }
        
        let splittedArray = sessionSplitter.splitSession()
        return splittedArray
    }
    
    func runSinks(events:[Data]) {
        print("@Func-runSink in SessionController")
        // From here, this function is responsible for letting the splittedArray be uploaded or stored somehow.
        // Handle and upload
        
        let response = CloudKitSink.uploadSplitSession(events: events, sessionIdentifier: self.currentSession?.sessionIdentifier.description ?? "NA")
        print("\tAble to upload to iCloud: \(response)")
    }
    
    /**
    Function for getting the duration of the session. If the session is ongoing the returned value reflects the current duration.

    - Parameter session: The session we are interested in
     
    - Returns: Will return the duration of the session as a `String`.
    */
    func getSessionDurationString(session:Session) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar
            .dateComponents([.day, .hour, .minute, .second],
                            from: session.start_time,
                            to: session.end_time ?? Date())
        return String(format: "%02dh:%02dm:%02ds",
                      components.hour ?? 00,
                      components.minute ?? 00,
                      components.second ?? 00)
    }

    /**
     Will return the number of events gathered by the session
     */
    func getNumberOfEvents() -> Int{
        
        guard self.currentSession != nil else { /* Handle nil case */ return 0 }
        
        return self.currentSession?.getNumberOfEvents() ?? 0
    }
    
    #if os(iOS)
    // No heart rate sensor
    #else
    func getLatestBatteryWatchEvent() -> String{
        let event = currentSession!.getLatestBatteryWatchEvent()
        let batteryPercStr = event.getPercent()
        return batteryPercStr.description + "%"
    }
    
    func getLatestHeartRateData() -> String{
        let event = currentSession!.getLatestHREvent()
        let hrStr = event?.getHR().description ?? "---"
        return hrStr
    }
    #endif
}
