//
//  SensorInterface.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

protocol SensorInterface {
    // Information about the sensor
    var sensorName:SensorEnumeration { get }
    func startSensor(session:Session) -> Bool
    func stopSensor() -> Bool
    func collectEvent()
    func storeEvent(data:Data)
//    func getLastEvent() -> Event
}
