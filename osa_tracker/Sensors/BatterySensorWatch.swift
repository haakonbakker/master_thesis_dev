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
    override func startSensor(session:Session) -> Bool {
        
        currentSession = session
        // Need to say to the system we want to monitor the battery.
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        // Configure a timer to fetch the accelerometer data.
        self.timer = Timer(fire: Date(), interval: (self.samplingRate), repeats: true, block: { (timer) in
            // Get the battery data on an interval.
            self.collectEvent()
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
    
    func collectEvent(){
        let event = createEvent()
        let encodedEvent = encodeEvent(event:event)
        if let jsonEncodedEvent = encodedEvent {
            storeEvent(data:jsonEncodedEvent)
        } else {
            fatalError("@func - collectEvent. encodedEvent is nil")
        }
    }
    
    func createEvent() -> BatteryEvent{
        let batteryLevel = WKInterfaceDevice.current().batteryLevel
        let device = WKInterfaceDevice.current().model
        let batteryState = WKInterfaceDevice.current().batteryState.rawValue
        
        let event = BatteryEvent(device: device, batteryLevel: batteryLevel, batteryState: batteryState, sessionIdentifier: sessionIdentifier?.description ?? "NA")
        return event
    }
    
    func encodeEvent(event:BatteryEvent) -> Data?{
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
    #endif
    
    func getLastEvent() -> BatteryEvent{
        return createEvent()
    }
}
