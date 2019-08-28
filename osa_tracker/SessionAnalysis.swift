//
//  SessionAnalysis.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI

struct SessionAnalysis : View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Detected apnea occurences: 4").font(.headline)
            Text("Analysis: Signs of sleep apnea").font(.subheadline)
            Text("Sleep analysis")
//            User should be able to slide between different sensor data
            Text("Graphs here comes").font(.title)
            Spacer()
        }
    }
}

#if DEBUG
struct SessionAnalysis_Previews : PreviewProvider {
    static var previews: some View {
        SessionAnalysis()
    }
}
#endif
