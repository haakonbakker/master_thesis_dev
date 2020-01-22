//
//  AggregatedMetric.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 22/01/2020.
//  Copyright © 2020 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class AggregatedMetric:EventProtocol{
    var sensorName: String
    var timestamp: TimeInterval
    var sessionIdentifier:String
    
    private var event:EventData
    
    private struct EventData:Codable{
        var metricValue:Double
        var type:String
    }
    
    init(metricValue:Double, type:String, sessionIdentifier:String?) {
        self.timestamp = Date().timeIntervalSince1970
        self.sensorName = "AggregatedMetric"
        self.event = EventData(metricValue: metricValue, type: type)
        self.sessionIdentifier = sessionIdentifier ?? "NA"
    }
    
    static func encodeEvent(event: AggregatedMetric) -> Data? {
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
