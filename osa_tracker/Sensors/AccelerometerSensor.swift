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
    
    override init(sensorEnum:SensorEnumeration = .Accelerometer) {
        super.init(sensorEnum: sensorEnum)
        self.events = []
        
    }
    
    override init(sensorEnum:SensorEnumeration = .Accelerometer, sessionIdentifier:UUID) {
        super.init(sensorEnum: sensorEnum, sessionIdentifier:sessionIdentifier)
        self.events = []
        
    }
    
    override func getNumberOfEvents() -> Int{
        return self.events.count
    }
    
    func startAccelerometers() {
       // Make sure the accelerometer hardware is available.
       if self.motion.isAccelerometerAvailable {
          self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
          self.motion.startAccelerometerUpdates()

          // Configure a timer to fetch the data.
          self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                repeats: true, block: { (timer) in
             // Get the accelerometer data.
             if let data = self.motion.accelerometerData {
                let timestamp = Date()
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z
//                print(z)
                // Use the accelerometer data in your app.
                
                // Add the event to the dataset
                let event = AccelerometerEvent(x: x, y: y, z: z, timestamp: timestamp)
                self.events.append(event)
                self.exportEvent()
                
             }
          })

          // Add the timer to the current run loop.
        RunLoop.current.add(self.timer!, forMode: .default)
       }
    }
    
    /**
     Will start the sensor. It will collect data on a given interval.
    */
    override func startSensor() -> Bool{
        print("Will start the accelerometer sensor")
        self.startAccelerometers()
        return true
    }
    
    /**
     Will stop the sensor.
    */
    override func stopSensor() -> Bool{
        print("Will stop the accelerometer sensor")
        // TODO: stop the accelerometer
        return true
    }
    
    override func exportEvents() -> String{
         var jsonString = ""
         for event in self.events{
             jsonString += self.getEventAsString(event: event as! AccelerometerEvent) + "\n" // Adding newline here - can we move this to the sessionController?
         }
         return jsonString
         
     }
     
     override func getEventAsString(event:Any) -> String{
         let event = event as! AccelerometerEvent
         do {
            // data we are getting from network request
             let encoder = JSONEncoder()
             encoder.outputFormatting = .sortedKeys
             let res = try encoder.encode(event)
             print(res)
             if let json = String(data: res, encoding: .utf8) {
               print("json", json)
                 return json
             }
             
             
         } catch { print(error) }
         return "Not able to return as string"
         
     }
}
