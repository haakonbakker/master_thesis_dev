//
//  MetaEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 13/10/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#else
import WatchKit
#endif

struct MetaStartEvent: EventProtocol, Codable {
    var sessionIdentifier: String
    
    var timestamp: TimeInterval
    
    var sensorName: String
    private var event:EventData
    
    private struct EventData:Codable{
        var sensorList:[String]
        var type:String = "Start"
        
        
        #if os(iOS)
        var device = UIDevice.current.model
        var version = UIDevice.current.systemVersion
        #endif
        
        #if os(watchOS)
        var device = WKInterfaceDevice.current().model
        var version = WKInterfaceDevice.current().systemVersion
        #endif
        
    }
    
    init(sensorList:[Sensor], sessionIdentifier:String) {
        self.timestamp = Date().timeIntervalSince1970
        self.sensorName = "MetaStartEvent"
        self.sessionIdentifier = sessionIdentifier
        
        let sensorListStr = sensorList.map({ $0.description })
        self.event = EventData(sensorList: sensorListStr)
    }
}
