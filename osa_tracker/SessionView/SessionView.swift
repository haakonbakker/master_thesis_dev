//
//  SessionView.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI

struct SessionView : View {
    let sessionController:SessionController
    @State private var sessionStarted: Bool = false
    
    @State var session:Session?
    
    var body: some View {
        
        VStack{
            
            if sessionStarted{
                Text(self.session!.duration)
                Text("Session has started")
//                SessionViewActive(session: $session)
            }else{
                Text("New Session").font(.largeTitle)
                Text("")
                Spacer()
                Button(action: {self.sessionStarted=true;
                    self.session = self.sessionController.startSession()}) {
                    Text("Start session")
                }
            }
            
        }
        
    }
}

#if DEBUG
struct SessionView_Previews : PreviewProvider {
    static var previews: some View {
        SessionView(sessionController: SessionController())
    }
}
#endif

