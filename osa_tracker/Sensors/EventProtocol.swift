//
//  Event.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

protocol EventProtocol:Codable {
    var timestamp:UInt64 { get set }
    var sensorName:String { get set }
    var sessionIdentifier:String { get set }
}
