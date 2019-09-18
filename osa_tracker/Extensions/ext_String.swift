//
//  ext_String.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 04/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation



extension String{
    func get_time_stamp() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        return formatter.string(from: date)
    }
    


}
