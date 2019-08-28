//
//  SessionDetailView.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI

struct SessionDetailView : View {
    let s1 = SessionInfo()
    let sa1 = SessionAnalysis()
    
    let sessionName = "June 9th - June 10th"
    var body: some View {
        VStack(alignment: .leading){
            s1
            Spacer(minLength: 5)
            sa1
        }.navigationBarTitle(Text(sessionName))
        
    }
}

#if DEBUG
struct SessionDetailView_Previews : PreviewProvider {
    static var previews: some View {
        SessionDetailView()
    }
}
#endif
