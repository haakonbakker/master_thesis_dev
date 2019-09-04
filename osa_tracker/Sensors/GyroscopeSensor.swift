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

class GyroscopeSensor: SensorInterface, GyroscopeInterface, ObservableObject {
    var motion:CMMotionManager
    var timer:Timer?
    var sensorName: SensorEnumeration
    
    @Published var gyroRotation:[Double]
    
    @Published var gyroData:GyroDataPoint // Should add it as some form of array
    
    init() {
        motion = CMMotionManager()
        timer = Timer()
        sensorName = .GyroscopeSensor
        gyroRotation = [0.0, 0.0, 0.0]
        gyroData = GyroDataPoint()
    }
    
    func startGyros() {
        
       if motion.isGyroAvailable {
          self.motion.gyroUpdateInterval = 1.0 / 60.0 // Sets the update interval for the sensor data
          self.motion.startGyroUpdates()

          // Configure a timer to fetch the accelerometer data.
          self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                 repeats: true, block: { (timer) in
             // Get the gyro data.
             if let data = self.motion.gyroData {
                let x = data.rotationRate.x
                let y = data.rotationRate.y
                let z = data.rotationRate.z

                print("x: \(x)")
                print("y: \(y)")
                print("z: \(z)")
                self.gyroRotation = [x, y, z]
                
                // Use the gyroscope data in your app.
             }
          })

          // Add the timer to the current run loop.
        RunLoop.current.add(self.timer!, forMode: .default)
        
       }
    }
    
    func stopGyros() {
       if self.timer != nil {
          self.timer?.invalidate()
          self.timer = nil

          self.motion.stopGyroUpdates()
       }
    }
}
