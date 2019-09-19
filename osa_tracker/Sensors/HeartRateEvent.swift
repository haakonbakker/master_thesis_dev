//
//  HeartRateEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

struct HeartRateEvent:EventProtocol {
    var sensorName: String
    var timestamp: Date
    
    init() {
        self.timestamp = Date()
        self.sensorName = "Heart Rate"
    }
}
