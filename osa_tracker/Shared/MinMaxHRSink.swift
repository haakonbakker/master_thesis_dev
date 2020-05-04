//
//  MinMaxHRSink.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 02/04/2020.
//  Copyright © 2020 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class MinMaxHRSink: Sink {
    static func runSink(events: [Data]) -> [Data] {
        var min = -1
        var max = -1
        
        var minEvent:Data? = nil
        var maxEvent:Data? = nil
        
        for event in events{
            let serializedJson = try? JSONSerialization.jsonObject(with: event, options: []) as? [String:AnyObject]
            
            if("Heart Rate" == serializedJson!["sensorName"] as! String){
                let hr = serializedJson!["event"]!["heartRate"] as! Int
                
                // Check if the HR is under currentMin
                if(hr < min || min == -1){
                    // This is current min
                    minEvent = event
                    min = hr
                }else if(hr > max || max == -1){
                    // This is current max
                    maxEvent = event
                    max = hr
                }
            }
        }
        
        return [minEvent!, maxEvent!]
    }
}
