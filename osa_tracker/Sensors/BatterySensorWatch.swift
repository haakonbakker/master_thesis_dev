//
//  BatterySensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 19/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import WatchKit

class BatterySensorWatch: Sensor {
    var timer:Timer?
    var samplingRate:Double
    
    init(sensorEnum: SensorEnumeration = .BatterySensor, samplingRate:Double) {
        self.samplingRate = samplingRate
        super.init()
        self.events = []
    }
    
    override func startSensor() -> Bool {
        // Need to say to the system we want to monitor the battery.
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        
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
        let batteryLevel = WKInterfaceDevice.current().batteryLevel
        let device = WKInterfaceDevice.current().model
        let batteryState = WKInterfaceDevice.current().batteryState.rawValue
        let event = BatteryEvent(device: device, batteryLevel: batteryLevel, batteryState: batteryState)
        self.events.append(event)
        self.exportEvent()
    }
    

    

    
    override func getNumberOfEvents() -> Int{
        return self.events.count
    }
    
    override func exportEvent(){
        let event = self.events[0] as! BatteryEvent
//        print("Type of event:")
//        print("\(type(of: event))")
        do {
           // data we are getting from network request
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let res = try encoder.encode(event)
//            print(res)
            if let json = String(data: res, encoding: .utf8) {
//              print("json", json)
            }
            

        } catch { print(error) }
    }
    
    func getEventAsString(event:BatteryEvent) -> String{
        do {
           // data we are getting from network request
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            let res = try encoder.encode(event)
//            print(res)
            if let json = String(data: res, encoding: .utf8) {
//              print("json", json)
                return json
            }
            
            
        } catch { print(error) }
        return "Not able to return as string"
    }
    
    override func exportEvents() -> String{
        var jsonString = ""
        for event in self.events{
            jsonString += self.getEventAsString(event: event as! BatteryEvent) + "\n" // Adding newline here - can we move this to the sessionController?
        }
        return jsonString
    }
}
