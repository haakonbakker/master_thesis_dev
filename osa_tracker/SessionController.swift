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

class SessionController {
    
    init() {
        
    }
    
    func getSessions() -> [Session]{
        let sessions = [Session(id:0), Session(id:1), Session(id:2)]
        
        return sessions
    }
    
    func startSession() -> Session{
        print("Will start the session")
        var session = Session(id:3)
        
        initSession(session:session)
        return session
    }
    
    func initSession(session:Session){
        
    }
    
    func startAudioRecording(){
//        Will start to record audio
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
