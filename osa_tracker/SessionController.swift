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

    
    
    
    @Published var currentSession:Session?
    #if os(iOS)
    var microphoneSensor:MicrophoneSensor!
    #else
    
    #endif

    var gyroscopeSensor:GyroscopeSensor!
    var eventTimer:Timer?
    var sessionSplitter:SessionSplitter?
    
    
    init() {
        // Splunk setup
//        let spl_hec = SplunkHEC(splunkInstance: SplunkInstance(theProtocol: "http", port: "8088", ip: "127.0.0.1"))
//        print(spl_hec)
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
        currentSession = Session(id:3, wakeUpTime: wakeUpTime, sensorList: sensorList, sessionIdentifier: SESSION_UUID)
        
        guard currentSession != nil else {
            print("No active session")
            fatalError("currentSession is nil - cannot handle")
        }
        
        _ = currentSession?.startSession()
        self.sessionSplitter = SessionSplitter(session: self.currentSession!)
        // Fire the timer, so that events will be processes batchwise.
        self.eventTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {_ in
            let numberOfEvents = self.getNumberOfEvents()
            print("Number of events: ", numberOfEvents)
            self.splitSession()
        }

        return currentSession!
    }
    
    /**
        Will call the session object and end the current session.
     */
    func endSession(){
        if(self.currentSession?.hasEnded == false){
            _ = self.currentSession?.endSession()
            self.currentSession?.hasEnded = true
//            self.exportEvents()
            print("Session has ended")
            
            if self.eventTimer != nil {
              self.eventTimer?.invalidate()
              self.eventTimer = nil
            }
            
        }else{
            print("Session already ended")
        }
    }
    
    /**
     This method should be called at an interval during a session.
     It collects events that the sensors has gathered until this point.
     */
    func splitSession(){
        print("@Func-splitSession in SessionController")
        
        guard let currentSession = self.currentSession else {
            print("\tNo active currentSession")
            fatalError("\tcurrentSession is nil - cannot handle")
        }
        
        guard let sessionSplitter = self.sessionSplitter else {
            print("\tNo active sessionSplitter")
            fatalError("\tsessionSplitter is nil - cannot handle")
        }
        
        let splitTime = Date()
        let splittedArray = sessionSplitter.splitSession(date:splitTime)
        print(splittedArray.count)
        // From here, this function is responsible for letting the splittedArray be uploaded or stored somehow.
        
        // Handle and upload
        
        let response = CloudHandler.uploadSplitSession(events: splittedArray, sessionIdentifier: self.currentSession?.sessionIdentifier.description ?? "NA")
        print("\tAble to upload to iCloud: \(response)")
        // Update the currentsession.uploadedEventsCount
        
        currentSession.updateUploadedEventsCount(uploadedEvents: splittedArray.count)
    }
    
    /**
    Function for getting the duration of the session. If the session is ongoing the returned value reflects the current duration.

    - Parameter session: The session we are interested in
     
    - Returns: Will return the duration of the session as a `String`.
    */
    func getSessionDurationString(session:Session) -> String {
        if(session.hasEnded){
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar
                .dateComponents([.day, .hour, .minute, .second],
                                from: session.start_time,
                                to: session.end_time!)
            return String(format: "%02dh:%02dm:%02ds",
                          components.hour ?? 00,
                          components.minute ?? 00,
                          components.second ?? 00)
        }else{
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar
                .dateComponents([.day, .hour, .minute, .second],
                                from: session.start_time,
                                to: Date())
            return String(format: "%02dh:%02dm:%02ds",
                          components.hour ?? 00,
                          components.minute ?? 00,
                          components.second ?? 00)
        }
        
    }

    /**
     Will return the number of events gathered by the session
     */
    func getNumberOfEvents() -> Int{
        
        guard self.currentSession != nil else { /* Handle nil case */ return 0 }
        
        return self.currentSession?.getNumberOfEvents() ?? 0
    }
    
    func exportEvents(){
        
        // The following needs to be done:
        /*
         - When saving the session, the uuid needs to be attached to all sensor-events - DONE
         - Meta event should be created at the begining, and at the end
         - The recording.m4a also needs to get the uuid - DONE
         - The file on the watch needs to be sent to the phone and stored there.
         */
        
        // We do not want to export events before the session has ended
        if(currentSession?.hasEnded == false){
            return
        }
        
        print("Will export events to file")
        
//        let file = "file.txt" //this is the file. we will write to and read from it
        let date_string = Date().date_to_string()
        
        
        print(date_string)
        let filename = date_string + "-" + currentSession!.sessionIdentifier.description + ".json" //this is the filename. We will write it to the system

        var text = ""
        // Looping over all the events in every sensor and storing in text variable.
        for sensor in currentSession!.sensorList{
            for event in sensor.events{
                text += sensor.getEventAsString(event: event) + ","
                // text += "," // Could use this to separate JSON data
            }
        }
        text = String(text.dropLast()) // removing last ','
        text = "[" + text + "]" // Producing valid JSON
//        print(text)

        
        let fh = FileHandler()
        let _ = fh.writeFile(filename: filename, contents: text)
        
        let ch = CloudHandler()
        ch.upload_text(sessionIdentifier: self.currentSession?.sessionIdentifier.description ?? "NoSessionIdentifierProvided", text: text)

    }
    
    
//    func getLatestEvent(sensor_enum:SensorEnumeration){
//        currentSession!.getLatestEvent(sensor_enum: sensor_enum)
//    }
    
    
    
    
    
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
