//
//  GyroscopeSensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 04/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import CoreMotion
import Combine


struct GyroDataPoint{
    var timestamp:Date
    var x: Double
    var y: Double
    var z: Double
    
    init(){
        self.x = 0
        self.y = 0
        self.z = 0
        self.timestamp = Date()
    }
}

class GyroscopeSensor: Sensor, GyroscopeInterface, ObservableObject {
    var motion:CMMotionManager
    var timer:Timer?
    
    @Published var gyroRotation:[Double]
    
    @Published var gyroData:GyroDataPoint // Should add it as some form of array
    
//    @Published var events:[GyroscopeEvent]
    
    init() {
        motion = CMMotionManager()
        timer = Timer()
        gyroRotation = [0.0, 0.0, 0.0]
        gyroData = GyroDataPoint()
        super.init(sensorEnum: .GyroscopeSensor)
        self.events = []
        
    }
    
    init(sessionIdentifier:UUID) {
        motion = CMMotionManager()
        timer = Timer()
        gyroRotation = [0.0, 0.0, 0.0]
        gyroData = GyroDataPoint()
        super.init(sensorEnum: .GyroscopeSensor, sessionIdentifier:sessionIdentifier)
        self.events = []
        
    }
    
    func startGyros() {
        
        if motion.isGyroAvailable {
            self.motion.gyroUpdateInterval = 1.0 / 60.0 // Sets the update interval for the sensor data
            self.motion.startGyroUpdates()

            // Configure a timer to fetch the accelerometer data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block:
                {(timer) in
                    self.collectEvent()
                })

            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer!, forMode: .default)

        }else{
            print("@func - startGyros -> gyro is not available.")
        }
    }
    
    override func startSensor(session:Session) -> Bool {
        currentSession = session
        print("Will start Gyroscope")
        self.startGyros()
        return true
    }
    
    override func stopSensor() -> Bool {
        print("Will stop Gyroscope")
        self.stopGyros()
        return true
    }
    
    func stopGyros() {
       if self.timer != nil {
          self.timer?.invalidate()
          self.timer = nil

          self.motion.stopGyroUpdates()
       }
    }
    
    override func getNumberOfEvents() -> Int{
        return self.events.count
    }
    
    
    func collectEvent(){
        let event = createEvent()
        if let unwrapedEvent = event{
            let encodedEvent = self.encodeEvent(event: unwrapedEvent)
            if let jsonEncodedEvent = encodedEvent {
                storeEvent(data:jsonEncodedEvent)
            } else {
                fatalError("@func - collectEvent. encodedEvent is nil")
            }
        }else{
            fatalError("@func - collectEvent. event is nil")
        }
    }
    
    func createEvent() -> GyroscopeEvent?{
        // Get the gyro data.
        if let data = self.motion.gyroData {
           let timestamp = Date()
           let x = data.rotationRate.x
           let y = data.rotationRate.y
           let z = data.rotationRate.z

           
           self.gyroRotation = [x, y, z]
           
           // Add the event to the dataset
           let event = GyroscopeEvent(x: x, y: y, z: z, timestamp: timestamp, sessionIdentifier:self.sessionIdentifier?.description ?? "NA")
           return event
        }
        return nil
    }
    
    func encodeEvent(event:GyroscopeEvent) -> Data?{
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let res = try encoder.encode(event)
            print(res)
//          Converting to String representation:
//            if let json = String(data: res, encoding: .utf8) {
//              print("json:\n", json)
//            }
            return res
        }catch{
            print(error)
        }
        return nil
    }
    
    func storeEvent(data:Data){
        self.currentSession?.eventList.append(data)
    }
}
