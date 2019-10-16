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
    
    init() {
        
        
        // Splunk setup
        let spl_hec = SplunkHEC(splunkInstance: SplunkInstance(theProtocol: "http", port: "8088", ip: "127.0.0.1"))
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
        #if os(iOS)
        let sensorList = [GyroscopeSensor(sessionIdentifier: SESSION_UUID), MicrophoneSensor(sessionIdentifier: SESSION_UUID), BatterySensor(samplingRate: 5, sessionIdentifier: SESSION_UUID)]
        #else
        let sensorList = [GyroscopeSensor(sessionIdentifier: SESSION_UUID), AccelerometerSensor(sessionIdentifier: SESSION_UUID), BatterySensorWatch(samplingRate: 5, sessionIdentifier: SESSION_UUID), HeartRateSensor(sessionIdentifier: SESSION_UUID)]
        #endif
        
//        let sensorList = [BatterySensor(samplingRate: 5)]
        print("Will start the session")
        currentSession = Session(id:3, wakeUpTime: wakeUpTime, sensorList: sensorList, sessionIdentifier: SESSION_UUID)
        
        guard currentSession != nil else {
            print("No active session")
            fatalError("currentSession is nil - cannot handle")
        }
        
        for sensor in self.currentSession!.sensorList {
            sensor.startSensor()
        }
        
        return currentSession!
    }
    
    /**
        
     */
    func endSession(){
        if(self.currentSession?.hasEnded == false){
            for sensor in (self.currentSession?.sensorList)! {
                sensor.stopSensor()
                if sensor.events.count > 0 {
                    sensor.exportEvent()
                }
                
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
        
        guard self.currentSession != nil else { /* Handle nil case */ return 0 }
        
        // Should do:
        // For every sensor; return count
        var numberOfEvents = 0
        
        for sensor in self.currentSession!.sensorList {
            numberOfEvents += sensor.getNumberOfEvents()
        }

        return numberOfEvents
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
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//            let fileURL = dir.appendingPathComponent(file)
//            print(fileURL)
//            //writing
//            do {
//                try text.write(to: fileURL, atomically: false, encoding: .utf8)
//            }
//            catch {/* error handling here */}
//
//            //reading
//            do {
//                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
//            }
//            catch {/* error handling here */}
//        }
    }
    
    
//    func getLatestEvent(sensor_enum:SensorEnumeration){
//        currentSession!.getLatestEvent(sensor_enum: sensor_enum)
//    }
    
    
    
    func getLatestBatteryWatchEvent() -> String{
        let event = currentSession!.getLatestBatteryWatchEvent()
        let batteryPercStr = event.getPercent()
        return batteryPercStr.description + "%"
    }
    
    #if os(iOS)
    // No heart rate sensor
    #else
    func getLatestHeartRateData() -> String{
        let event = currentSession!.getLatestHREvent()
        let hrStr = event?.getHR().description ?? "---"
        return hrStr
    }
    #endif
}
