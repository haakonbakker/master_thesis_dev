//
//  HeartRateSensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import WatchKit
import HealthKit

// Inspiration: https://github.com/coolioxlr/watchOS-3-heartrate/blob/master/VimoHeartRate%20WatchKit%20App%20Extension/InterfaceController.swift

class HeartRateSensor:Sensor, HKWorkoutSessionDelegate{
    
    var currentQuery : HKQuery?
    let healthStore = HKHealthStore()
    //State of the app - is the workout activated
    var workoutActive = false
    var session : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    
    
    
    override init(sensorEnum: SensorEnumeration = .HeartRateSensor) {
        super.init(sensorEnum: sensorEnum)
        self.events = []
    }
    
    override init(sensorEnum: SensorEnumeration = .HeartRateSensor, sessionIdentifier:UUID) {
        super.init(sensorEnum: sensorEnum, sessionIdentifier:sessionIdentifier)
        self.events = []
    }
    
    override func startSensor() -> Bool {
        print("Starting heart rate")
        
        guard HKHealthStore.isHealthDataAvailable() == true else {
            return false
        }
    
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            return false
        }
        
        let dataTypes = Set(arrayLiteral: quantityType)
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
            if success == false {
//                self.displayNotAllowed()
            }
        }
    
        
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return false
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .crossTraining
        workoutConfiguration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        session?.startActivity(with: Date())
        self.workoutActive = true
        return true
    }
    
    override func stopSensor() -> Bool {
        session?.end()
        return true
    }
    
    override func getNumberOfEvents() -> Int{
        return self.events.count
    }
    
    override func exportEvent(){
        let event = self.events[0] as! HeartRateEvent
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
    
    func getEventAsString(event:HeartRateEvent) -> String{
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
            jsonString += self.getEventAsString(event: event as! HeartRateEvent) + "\n" // Adding newline here - can we move this to the sessionController?
        }
        return jsonString
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
            switch toState {
                case .running:
                    workoutDidStart(date)
                case .ended:
                    workoutDidEnd(date)
                default:
                    print("Unexpected state \(toState)")
            }
        }
        
        func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
            // Do nothing for now
            print("Workout error")
        }
        
        func workoutDidStart(_ date : Date) {
            if let query = createHeartRateStreamingQuery(date) {
                self.currentQuery = query
                healthStore.execute(query)
            } else {
    //            label.setText("cannot start")
            }
        }
        
        func workoutDidEnd(_ date : Date) {
                healthStore.stop(self.currentQuery!)
    //            label.setText("---")
                session = nil
        }
        
        func updateHeartRate(_ samples: [HKSample]?) {
            guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            print("Current heart rate: " + value.description)
            // Add the event to the dataset
            if let session_uuid = self.sessionIdentifier {
                let event = HeartRateEvent(unit: "count/min", heartRate: value, sessionIdentifier: session_uuid)
                self.events.append(event)
            }else{
                let event = HeartRateEvent(unit: "count/min", heartRate: value)
                self.events.append(event)
            }
            
//            self.exportEvent()
        }
    
    override func getEventAsString(event:Any) -> String{
            let event = event as! HeartRateEvent
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
        
        func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
            guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
            
            let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
            
            //let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
            
            
            let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
                self.updateHeartRate(sampleObjects)
            }
            
            heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
                self.updateHeartRate(samples)
            }
            return heartRateQuery
        }
    
    func getLastEvent() -> HeartRateEvent?{
        guard let event = self.events.last else {
            return nil
        }
        return self.events.last as! HeartRateEvent
    }
}
