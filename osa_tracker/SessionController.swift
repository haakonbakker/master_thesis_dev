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
    var microphoneSensor:MicrophoneSensor!
    var gyroscopeSensor:GyroscopeSensor!
    var sensorList:[Sensor]
    init() {
        self.microphoneSensor = MicrophoneSensor()
        self.gyroscopeSensor = GyroscopeSensor()
        self.sensorList = [self.gyroscopeSensor, self.microphoneSensor]
        
        
        // Splunk setup
        let spl_hec = SplunkHEC(splunkInstance: SplunkInstance(theProtocol: "http", port: "8088", ip: "127.0.0.1"))
    }
    
    func getSessions() -> [Session]{
        let sessions = [Session(id:0), Session(id:1), Session(id:2)]
        return sessions
    }
    
    func endSession(){
        if(self.currentSession?.hasEnded == false){
            self.microphoneSensor.endRecording(success: true)
            self.gyroscopeSensor.stopGyros()
            self.currentSession?.end_time = Date()
            print("Session has ended")
        }else{
            print("Session already ended")
        }
        
        
    }
    
    /**
    This function starts a new session.

    - Returns: A new Session instance.
    */
    func startSession(wakeUpTime:Date) -> Session{
        self.microphoneSensor = MicrophoneSensor()
        self.gyroscopeSensor = GyroscopeSensor()
        self.sensorList = [self.gyroscopeSensor, self.microphoneSensor]
        print("Will start the session")
        currentSession = Session(id:3, wakeUpTime: wakeUpTime)
        
        guard currentSession != nil else {
            print("No active session")
            return Session(id:-1)
        }
        
        initSession(session:currentSession!)
        return currentSession!
    }
    
    /**
    Initializes the session.

    - Parameter session: The session being initiated
    */
    func initSession(session:Session){
        let ableToStart = microphoneSensor.startRecording(sessionID: session.id)
        print("Phone is able to start recording: \(ableToStart)")
        
        gyroscopeSensor.startGyros()
        print("Started Gyroscope sensor")
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
                                to: session.end_time)
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

    func getNumberOfEvents() -> Int{
        // Should do:
        // For every sensor; return count
        var numberOfEvents = 0
        
        for sensor in self.sensorList {
            numberOfEvents += sensor.getNumberOfEvents()
        }
        
        return numberOfEvents
    }
    
}

class Session:Identifiable{
    var id:Int
    var timestamp:String
    var duration:String
    var start_time:Date
    var end_time:Date
    var hasEnded:Bool
    var wakeUpTime:Date
    var sensorList:[Sensor]
    
    
    init(id:Int){
        self.id = id
        self.duration = "6h23m"
        self.timestamp = "June 9th to June 10th"
        self.start_time = Date()
        self.end_time = Date()
        self.hasEnded = false
        self.sensorList = []
        self.wakeUpTime = Date()
    }
    
    init(id:Int, wakeUpTime:Date){
        self.id = id
        self.duration = "6h23m"
        self.timestamp = "June 9th to June 10th"
        self.start_time = Date()
        self.end_time = Date()
        self.hasEnded = false
        self.sensorList = []
        self.wakeUpTime = wakeUpTime
    }

    // Start the session here
    func startSession() -> Session{
        return Session(id:5)
    }
    
    // End the session here
    func endSession() -> Bool{
        return true
    }
    
    func getWakeUpTime() -> Date {
        return self.wakeUpTime
    }
    
    
}
