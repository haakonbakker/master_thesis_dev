//
//  AccelerometerSensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 25/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import CoreMotion

class AccelerometerSensor:Sensor, SensorInterface{
    
    let motion = CMMotionManager()
    var timer:Timer?
        
    override init(sensorEnum:SensorEnumeration = .Accelerometer, sessionIdentifier:UUID) {
        super.init(sensorEnum: sensorEnum, sessionIdentifier:sessionIdentifier)
    }
    
    /**
     Will start the sensor. It will collect data on a given interval.
    */
    override func startSensor(session:Session) -> Bool{
        currentSession = session
        print("Will start the accelerometer sensor")
        self.startAccelerometers()
        return true
    }
    
    /**
     Will stop the sensor.
    */
    override func stopSensor() -> Bool{
        print("Will stop the accelerometer sensor")
        // TODO: stop the
        self.timer?.invalidate()
        self.motion.stopAccelerometerUpdates()

        return true
    }
    
    func collectEvent() {
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
    
    func createEvent() -> AccelerometerEvent? {
        if let data = self.motion.accelerometerData {
            let timestamp = NSDate()
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            // Use the accelerometer data in your app.
            
            // Add the event to the dataset
            let event = AccelerometerEvent(x: x, y: y, z: z, timestamp: timestamp, sessionIdentifier: self.sessionIdentifier?.description ?? "NA")
            
            return event
            
         }
        return nil
    }
    
    func encodeEvent(event: AccelerometerEvent) -> Data? {
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
    
    func startAccelerometers() {
       // Make sure the accelerometer hardware is available.
       if self.motion.isAccelerometerAvailable {
          self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
//        self.motion.startAccelerometerUpdates(to: OperationQueue(), withHandler: {_,_ in self.collectEvent()})
          self.motion.startAccelerometerUpdates()

          // Configure a timer to fetch the data.
          self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                repeats: true, block: { (timer) in
             // Get the accelerometer data.
                    self.collectEvent()
          })

          // Add the timer to the current run loop.
        RunLoop.current.add(self.timer!, forMode: .default)
       }else{
        print("@func - startAccelerometers -> motion is not available.")
        }
        
    }
}
