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

}

class Session:Identifiable{
    var id:Int
    var timestamp:String
    var duration:String
    var start_time:Date?
    var end_time:Date?
    
    init(id:Int){
        self.id = id
        self.duration = "6h23m"
        self.timestamp = "June 9th to June 10th"
        self.start_time = Date()
        self.end_time = nil
    }
}
