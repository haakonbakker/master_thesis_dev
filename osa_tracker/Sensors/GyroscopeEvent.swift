//
//  GyroscopeEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

struct GyroscopeEvent: Event{
    var timestamp:Date
    var x: Double
    var y: Double
    var z: Double
    
    init(x:Double, y:Double, z:Double, timestamp:Date){
        self.x = x
        self.y = y
        self.z = z
        self.timestamp = timestamp
    }
}
