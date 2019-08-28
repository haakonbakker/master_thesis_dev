//
//  SessionInfo.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI

// Information for each session:
// Sleep time
// Analysis main findings
// Apneacount

struct SessionInfo : View {
    let time = "8h31m"
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Active sleep time: 7h59m").font(.headline)
            HStack{
                Text("Time in bed:")
                Text(time)
                Spacer()
            }
            Text("Graph of sleeping will be shown here")
        }
        
    }
}

#if DEBUG
struct SessionInfo_Previews : PreviewProvider {
    static var previews: some View {
        SessionInfo()
    }
}
#endif
