//
//  Sensor.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class Sensor: NSObject, SensorInterface {
    var sensorName: SensorEnumeration
    
    
    init(sensorEnum:SensorEnumeration = .Sensor) {
        self.sensorName = sensorEnum
    }
    
    func getNumberOfEvents() -> Int{
        return 0
    }
    
}
