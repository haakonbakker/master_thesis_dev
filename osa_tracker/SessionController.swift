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
    init() {
        
        
        // Splunk setup
        let spl_hec = SplunkHEC(splunkInstance: SplunkInstance(theProtocol: "http", port: "8088", ip: "127.0.0.1"))
    }
    
    func getSessions() -> [Session]{
        let sessions:[Session] = []
        return sessions
    }
    
    func endSession(){
        if(self.currentSession?.hasEnded == false){
            for sensor in (self.currentSession?.sensorList)! {
                sensor.stopSensor()
            }
            
            self.currentSession?.end_time = Date()
            self.currentSession?.hasEnded = true
            self.exportEvents()
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
        let sensorList = [GyroscopeSensor(), MicrophoneSensor(), BatterySensor(samplingRate: 5)]
        print("Will start the session")
        currentSession = Session(id:3, wakeUpTime: wakeUpTime, sensorList: sensorList)
        
        guard currentSession != nil else {
            print("No active session")
            fatalError("currentSession is nil - cannot handle")
        }
        
        initSession(session:currentSession!)
        return currentSession!
    }
    
    /**
    Initializes the session.

    - Parameter session: The session being initiated
    */
    func initSession(session:Session){        
        print("Will init the sensors")
        for sensor in self.currentSession!.sensorList {
            sensor.startSensor()
        }
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
     Will return the number of events gathered by all the sensors combined
     */
    func getNumberOfEvents() -> Int{
        // Should do:
        // For every sensor; return count
        var numberOfEvents = 0
        
        for sensor in self.currentSession!.sensorList {
            numberOfEvents += sensor.getNumberOfEvents()
        }
        
        return numberOfEvents
    }
    
    func exportEvents(){
        // We do not want to export events before the session has ended
        if(currentSession?.hasEnded == false){
            return
        }
        
        print("Will export events to file")
        
        let file = "file.txt" //this is the file. we will write to and read from it

        let text = "some text" //just a text

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(file)
            print(fileURL)
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}

            //reading
            do {
                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
    }
    
}
