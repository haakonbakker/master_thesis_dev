//
//  SinkInterface.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 22/01/2020.
//  Copyright © 2020 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

protocol Sink {
    static func runSink(events:[Data], sessionIdentifier:String) -> [Data]
}
