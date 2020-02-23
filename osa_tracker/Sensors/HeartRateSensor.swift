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
    var healthStore = HKHealthStore()
    //State of the app - is the workout activated
    var workoutActive = false
    var hksession : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    
    var latestHREvent:HeartRateEvent!
    
    override init(sensorEnum: SensorEnumeration = .HeartRateSensor, sessionIdentifier:UUID) {
        super.init(sensorEnum: sensorEnum, sessionIdentifier:sessionIdentifier)
    }
    
    override func startSensor(session:Session) -> Bool {
        currentSession = session
        self.healthStore = HKHealthStore() // Re-initiating this object
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
                print("Not authorized to use HealthKit.")
            }
        }

        // If we have already started the workout, then do nothing.
        if (hksession != nil) {
            return false
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .indoor
        
        do {
            hksession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            hksession?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        hksession?.startActivity(with: Date())
        self.workoutActive = true
        return true
    }
    
    override func stopSensor() -> Bool {
        self.workoutSession(hksession!, didChangeTo: .ended, from: .running, date: Date())
        self.hksession?.stopActivity(with: Date())
        self.workoutDidEnd(Date())
        hksession?.end()
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
        print("Workout error")
    }
    
    func workoutDidStart(_ date : Date) {
        if let query = createHeartRateStreamingQuery(date) {
            self.currentQuery = query
            healthStore.execute(query)
        }
    }
    
    func workoutDidEnd(_ date : Date) {
        hksession?.stopActivity(with: date)
        hksession = nil
    }
    
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
            self.collectEvent(sampleObjects)
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            self.collectEvent(samples)
        }
        return heartRateQuery
    }

    func getLastEvent() -> HeartRateEvent?{
        guard self.latestHREvent != nil else {
            return nil
        }
        return self.latestHREvent
    }

    func collectEvent(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        guard let sample = heartRateSamples.first else{return}
        
        let value = sample.quantity.doubleValue(for: self.heartRateUnit)
        
        let event = self.createEvent(value:value)
        let encodedEvent = self.encodeEvent(event: event)
        if let jsonEncodedEvent = encodedEvent {
            storeEvent(data:jsonEncodedEvent)
        } else {
            fatalError("@func - updateHeartRate in HeartRateSensor. encodedEvent is nil")
        }
        self.latestHREvent = event
    }
        
    func createEvent(value:Double) -> HeartRateEvent{
        return HeartRateEvent(unit: "count/min", heartRate: value, sessionIdentifier: self.sessionIdentifier?.description ?? "NA")
    }
    
    func encodeEvent(event:HeartRateEvent) -> Data?{
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
