//
//  BatterySensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 19/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import UIKit

class BatterySensor: Sensor {
    var timer:Timer?
    var samplingRate:Double
    var events:[BatteryEvent]
    
    init(sensorEnum: SensorEnumeration = .BatterySensor, samplingRate:Double) {
        self.samplingRate = samplingRate
        self.events = []
    }
    
    override func startSensor() -> Bool {
        // Need to say to the system we want to monitor the battery.
        #if os(iOS)
        UIDevice.current.isBatteryMonitoringEnabled = true
        #else
        fatalError("This sensor is not implemented for other OSes")
        #endif
        // Configure a timer to fetch the accelerometer data.
        self.timer = Timer(fire: Date(), interval: (self.samplingRate), repeats: true, block: { (timer) in
            // Get the battery data on an interval.
            
            self.gatherEvent()
        })

        // Add the timer to the current run loop.
        RunLoop.current.add(self.timer!, forMode: .default)
        
        return true
    }
    
    override func stopSensor() -> Bool{
        if self.timer != nil {
          self.timer?.invalidate()
          self.timer = nil
        }
        
        return true
    }
    
    /*
     Will gather battery information for the device.
     */
    func gatherEvent(){
        let event = BatteryEvent(device: UIDevice.current.model, batteryLevel: UIDevice.current.batteryLevel, batteryState: UIDevice.current.batteryState.rawValue)
        self.events.append(event)
        self.exportEvent(event: event)
    }
    
    func exportEvent(event:BatteryEvent){
        do {
           // data we are getting from network request
            let encoder = JSONEncoder()
            let res = try encoder.encode(event)
            print(res)
            if let json = String(data: res, encoding: .utf8) {
              print("json", json)
            }

        } catch { print(error) }
    }
    
    static func stringify(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
          options = JSONSerialization.WritingOptions.prettyPrinted
        }

        do {
          let data = try JSONSerialization.data(withJSONObject: json, options: options)
          if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
          }
        } catch {
          print(error)
        }

        return ""
    }
    
    override func getNumberOfEvents() -> Int{
        return self.events.count
    }
    
}
