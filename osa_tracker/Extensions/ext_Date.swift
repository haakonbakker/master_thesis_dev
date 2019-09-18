//
//  ext_Date.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

extension Date{
    func dateToHour(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        return formatter.string(from: date)
    }
}
