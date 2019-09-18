//
//  SessionViewActive.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI

struct SessionViewActive: View {
    @State var session:Session?
    
    var body: some View {
        Text("Will wake you up at \(Date().dateToHour(date: (session?.getWakeUpTime())!))")
    }
}

//struct SessionViewActive_Previews: PreviewProvider {
//    @State private var session: Session = Session(id:0)
//    static var previews: some View {
//        SessionViewActive(session: $session )
//    }
//}
