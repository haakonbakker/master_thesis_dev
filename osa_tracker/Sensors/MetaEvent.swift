//
//  MetaEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 13/10/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

struct MetaEvent: EventProtocol, Codable {
    var sessionIdentifier: String
    
    var timestamp: TimeInterval
    
    var sensorName: String
    
    private struct EventData:Codable{
        var sensorList:[String]
    }
    
    init(sensorList:[String], sessionIdentifier:String) {
        self.timestamp = Date().timeIntervalSince1970
        self.sensorName = "MetaEvent"
        self.sessionIdentifier = sessionIdentifier
    }
}
