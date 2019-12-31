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
    var HKsession : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    
    
    
    override init(sensorEnum: SensorEnumeration = .HeartRateSensor) {
        super.init(sensorEnum: sensorEnum)
        self.events = []
    }
    
    override init(sensorEnum: SensorEnumeration = .HeartRateSensor, sessionIdentifier:UUID) {
        super.init(sensorEnum: sensorEnum, sessionIdentifier:sessionIdentifier)
        self.events = []
    }
    
    override func startSensor(session:Session) -> Bool {
        currentSession = session
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
        if (HKsession != nil) {
            return false
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .crossTraining
        workoutConfiguration.locationType = .indoor
        
        do {
            HKsession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            HKsession?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        HKsession?.startActivity(with: Date())
        self.workoutActive = true
        return true
    }
    
    override func stopSensor() -> Bool {
        self.workoutSession(HKsession!, didChangeTo: .ended, from: .running, date: Date())
        self.HKsession?.stopActivity(with: Date())
        self.workoutDidEnd(Date())
        HKsession?.end()
        return true
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
            switch toState {
                case .running:
                    workoutDidStart(date)
                case .ended:
                    guard let query = currentQuery else { workoutDidEnd(date); return}
                    self.healthStore.stop(query)
                    self.workoutDidEnd(date)
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
            HKsession = nil
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

    func updateHeartRate(_ samples: [HKSample]?) {
        collectEvent()
        print("@func - updateHeartRate in HeartRateSensor.")
        
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        guard let sample = heartRateSamples.first else{return}
        
        let value = sample.quantity.doubleValue(for: self.heartRateUnit)
        print("\tCurrent heart rate: " + value.description)
        
        let event = self.createEvent(value:value)
        let encodedEvent = self.encodeEvent(event: event)
        if let jsonEncodedEvent = encodedEvent {
            storeEvent(data:jsonEncodedEvent)
        } else {
            fatalError("@func - updateHeartRate in HeartRateSensor. encodedEvent is nil")
        }
        self.events.append(event)
    }
    
    func collectEvent(){
        print("@func - collectEvent in HeartRateSensor")
        print("\tupdateHeartRate is the function that handles the collect for the HeartRateSensor")
    }
    
    func createEvent(value:Double) -> HeartRateEvent{
        let event = HeartRateEvent(unit: "count/min", heartRate: value, sessionIdentifier: self.sessionIdentifier?.description ?? "NA")
        return event
    }
    
    func encodeEvent(event:HeartRateEvent) -> Data?{
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let res = try encoder.encode(event)
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
