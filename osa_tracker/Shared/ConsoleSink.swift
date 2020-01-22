//
//  ConsoleSink.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 15/01/2020.
//  Copyright © 2020 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

class ConsoleSink:Sink{
    static func runSink(events:[Data]) -> [Data]{
        for event in events{
            let printable = String(decoding: event, as: UTF8.self)
            print(printable)
        }
        return events
    }
}
