//
//  GyroscopeDataView.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 04/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI
import Combine

struct GyroscopeDataView: View {
//    var gyroscopeRotation:[Double]
    
    @ObservedObject var gyroSensor:GyroscopeSensor
    
    var body: some View {
        VStack{
            Text("x: \(gyroSensor.gyroRotation[0].rounded(toPlaces: 2).description)")
            Text("y: \(gyroSensor.gyroRotation[1].rounded(toPlaces: 2).description))")
            Text("z: \(gyroSensor.gyroRotation[2].rounded(toPlaces: 2).description))")
        }
    }
}

//struct GyroscopeDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        GyroscopeDataView()
//    }
//}

