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
    var samplingRate:Double
        
    init(sessionIdentifier:UUID) {
        motion = CMMotionManager()
        timer = Timer()
        self.samplingRate = 1.0 / 60.0 // Sets the update interval for the sensor data
        super.init(sensorEnum: .GyroscopeSensor, sessionIdentifier:sessionIdentifier)
        self.events = []
        
    }
    
    override func startSensor(session:Session) -> Bool {
        currentSession = session
        print("Will start Gyroscope")
        if motion.isDeviceMotionAvailable {
            print("Motion available")
            print(motion.isGyroAvailable ? "Gyro available" : "Gyro NOT available")
            print(motion.isAccelerometerAvailable ? "Accel available" : "Accel NOT available")
            print(motion.isMagnetometerAvailable ? "Mag available" : "Mag NOT available")
            if(motion.isGyroAvailable){
                    self.startGyros()   
            }
            
        }
        return true
    }
    
    func startGyros() {
        self.motion.gyroUpdateInterval = self.samplingRate
        self.motion.startGyroUpdates()

        // Configure a timer to fetch the accelerometer data.
        self.timer = Timer(fire: Date(), interval: self.samplingRate, repeats: true, block: { (timer) in
                self.collectEvent()
            })

        // Add the timer to the current run loop.
        RunLoop.current.add(self.timer!, forMode: .default)
    }
    
    override func stopSensor() -> Bool {
        print("Will stop Gyroscope")
        if self.timer != nil {
           self.timer?.invalidate()
           self.timer = nil

           self.motion.stopGyroUpdates()
        }
        return true
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
        if let data = self.motion.deviceMotion {
           let timestamp = Date()
        
            let yaw = data.attitude.yaw
           let x = data.rotationRate.x
           let y = data.rotationRate.y
           let z = data.rotationRate.z
           
           // Add the event to the dataset
            let event = GyroscopeEvent(x: x, y: y, z: z, yaw:yaw, timestamp: timestamp, sessionIdentifier:self.sessionIdentifier?.description ?? "NA")
           return event
        }
        return nil
    }
    
    func encodeEvent(event:GyroscopeEvent) -> Data?{
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            let res = try encoder.encode(event)
            return res
        }catch{
            print(error)
        }
        return nil
    }
}
