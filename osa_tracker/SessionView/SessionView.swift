//
//  SessionView.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI

struct SessionView : View {
    var sessionController:SessionController
    @State private var sessionStarted: Bool = true
    @State private var sessionEnded:Bool = false
    var onDismiss: () -> ()
    
    @State var session:Session?
    
    @State var numberOfEvents = 0
    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.numberOfEvents = self.sessionController.getNumberOfEvents()
        }
    }

    
    var body: some View {
        
        VStack{
            if !sessionEnded{
                Text("😴Sleeping😴").font(.largeTitle)
                SessionViewActive(session: self.session!)
                
                Spacer()
                Text("Realtime data:")
                HStack{
                    Text("Duration:")
                    TimerView(nowDate:Date() , referenceDate:self.session!.start_time)
                }
                HStack{
                    Text("# Events:")
                    Text("\(self.numberOfEvents)").font(.footnote)
                    .onAppear(perform: {
                        _ = self.timer
                    })
                }
                
                ActiveGraphDataView()
                Button(action: {self.sessionEnded = true; self.sessionController.endSession()}) {
                    Text("End session").padding(30)
                }.padding(.top, 50)
        
            }else{
                // Session has ended
                Text("Session has ended").font(.largeTitle)
                
                // Displaying meta data about the session
                HStack{
                    Text("Duration:")
                    Text("\(self.sessionController.getSessionDurationString(session: self.session!))").font(.footnote)
                }
                HStack{
                    Text("# Events:")
                    Text("\(self.numberOfEvents)").font(.footnote)
                }
                Divider()
                // Button to perform ad-hoc analysis
                Button(action: {self.sessionController.microphoneSensor!.saveRecording()}) {
                    Text("Ad hoc analysis")
                }
                
                Spacer()
                // Dismiss the session
                // Todo: Call a save function effectively storing the session
                Button(action: {self.onDismiss(); print("Should save the session")}) {
                    Text("Save the session").padding(30)
                }
            }
        }.onDisappear(perform: {self.sessionController.endSession()})
        
    }
}

//#if DEBUG
//struct SessionView_Previews : PreviewProvider {
//    let showPop = true
//    static var previews: some View {
//        SessionView(sessionController: SessionController(), showPopover: showPop)
//    }
//}
//#endif
//
