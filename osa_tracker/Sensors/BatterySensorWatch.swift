//
//  BatterySensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 19/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
#if os(iOS)
#else
import WatchKit
#endif


class BatterySensorWatch: Sensor {
    var timer:Timer?
    var samplingRate:Double
    
    init(sensorEnum: SensorEnumeration = .BatterySensorWatch, samplingRate:Double) {
        self.samplingRate = samplingRate
        super.init(sensorEnum: sensorEnum)
        self.events = []
    }
    
    init(sensorEnum: SensorEnumeration = .BatterySensorWatch, samplingRate:Double, sessionIdentifier:UUID) {
        self.samplingRate = samplingRate
        super.init(sensorEnum: sensorEnum, sessionIdentifier:sessionIdentifier)
        self.events = []
    }
    
    #if os(iOS)
    #else
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
        
        
        if let sessionIdentifier = self.sessionIdentifier {
            let event = BatteryEvent(device: device, batteryLevel: batteryLevel, batteryState: batteryState, sessionIdentifier: sessionIdentifier.description)
            self.events.append(event)
        } else {
            let event = BatteryEvent(device: device, batteryLevel: batteryLevel, batteryState: batteryState)
            self.events.append(event)
        }
        
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
    
    override func getEventAsString(event:Any) -> String{
        let event = event as! BatteryEvent
        do {
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
    
    #endif
    func getLastEvent() -> BatteryEvent{
        return self.events.last as! BatteryEvent
    }
    
    override func getSplitEvents() -> String{
        if(self.events.count == 0){
            return ""
        }
        
        
        // First split the array to get a reasonable number of events
        // How many to split? Depends on the sensor
        
        let indexToSplitAt = self.getIndexToSplitAt()
        
        print(indexToSplitAt)
        var splittedEvents = self.events[0...indexToSplitAt]
        self.events = Array(self.events[indexToSplitAt...self.events.count-1])
        
        var jsonString = ""
        for event in splittedEvents{
            jsonString += self.getEventAsString(event: event as! BatteryEvent) // Adding newline here - can we move this to the sessionController?
            jsonString += ","
        }
        print(jsonString)
//        jsonString = "[" + jsonString + "]" // Producing valid JSON
        return jsonString
    }
    
    func getIndexToSplitAt() -> Int{
        if self.events.count < 200 {
            return self.events.count - 1
        }else{
            return 200
        }
    }
    
}
