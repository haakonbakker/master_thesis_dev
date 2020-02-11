//
//  FilterSink.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 22/01/2020.
//  Copyright © 2020 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class FilterSink:Sink{
    
    static func runSink(events: [Data]) -> [Data] {
        
        var mutableEvents = events
        mutableEvents.removeAll(where: {event in
            let _ = try? JSONSerialization.jsonObject(with: event, options: []) as? [String:AnyObject]
            // Will never remove anything, we cannot know what the user wants to remove.
            return false
        })
        return mutableEvents
    }
    
    static func runSink(events: [Data], sensorsToRemove:[String]) -> [Data]{
        if (events.isEmpty){return events}
        
        var mutableEvents = events
        mutableEvents.removeAll(where: {event in
            let serializedJson = try? JSONSerialization.jsonObject(with: event, options: []) as? [String:AnyObject]
            let sensorName = serializedJson!["sensorName"] as! String
            return sensorsToRemove.contains(sensorName)
        })
        return mutableEvents
    }
}
