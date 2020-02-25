//
//  AggregationSink.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 22/01/2020.
//  Copyright © 2020 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class AggregationSink: Sink {
    static func runSink(events: [Data]) -> [Data] {
        // Not applicable.
        fatalError()
    }
    
    static func runSink(events: [Data], sessionIdentifier:String) -> [Data] {
        var mutableEvents = events
        var aggregationEvents:[Int] = []
        mutableEvents.removeAll(where: {event in
            let serializedJson = try? JSONSerialization.jsonObject(with: event, options: []) as? [String:AnyObject]
            
            let sensorName = serializedJson!["sensorName"] as! String
            if(sensorName == "Heart Rate"){
                let event = serializedJson!["event"] as? [String:AnyObject]
                let hr = event!["heartRate"] as? Int
                aggregationEvents.append(hr!)
                return true
            }
            return false
        })
        
        mutableEvents.append(generateAggregatedHealthEvent(aggregationEvents: aggregationEvents, sessionIdentifier: sessionIdentifier))
        return mutableEvents
    }
    
    static func generateAggregatedHealthEvent(aggregationEvents: [Int], sessionIdentifier:String) -> Data{
        let sumHR = aggregationEvents.reduce(0, +)
        
        if (aggregationEvents.count) == 0 {return Data()};
        
        let avgHR:Double = Double(sumHR/aggregationEvents.count)
        let aggEvent = AggregatedMetric(metricValue: avgHR, type: "Avg(hr)", sessionIdentifier: sessionIdentifier)
        return AggregatedMetric.encodeEvent(event: aggEvent) ?? Data()
    }
}
