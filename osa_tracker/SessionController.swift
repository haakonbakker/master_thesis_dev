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
class SessionController{

    var currentSession:Session?
    var microphoneSensor:MicrophoneSensor!
    var gyroscopeSensor:GyroscopeSensor!
    
    init() {
        self.microphoneSensor = MicrophoneSensor()
        self.gyroscopeSensor = GyroscopeSensor()
        let spl_hec = SplunkHEC()
        
    }
    
    func getSessions() -> [Session]{
        let sessions = [Session(id:0), Session(id:1), Session(id:2)]
        
        return sessions
    }
    
    func endSession(){
        self.microphoneSensor.endRecording(success: true)
        self.gyroscopeSensor.stopGyros()
    }
    
    func startSession() -> Session{
        print("Will start the session")
        currentSession = Session(id:3)
        
        guard currentSession != nil else {
            print("No active session")
            return Session(id:-1)
        }
        
        initSession(session:currentSession!)
        return currentSession!
    }
    
    func initSession(session:Session){
        let ableToStart = microphoneSensor.startRecording(sessionID: session.id)
        print("Phone is able to start recording: \(ableToStart)")
        
        gyroscopeSensor.startGyros()
        print("Started Gyroscope sensor")
    }
    
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

    
}

class Session:Identifiable{
    var id:Int
    var timestamp:String
    var duration:String
    var start_time:Date
    var end_time:Date
    var hasEnded:Bool
    
    init(id:Int){
        self.id = id
        self.duration = "6h23m"
        self.timestamp = "June 9th to June 10th"
        self.start_time = Date()
        self.end_time = Date()
        self.hasEnded = false
    }
    
    
}
