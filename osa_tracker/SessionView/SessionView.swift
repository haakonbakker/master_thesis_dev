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
    @State private var sessionEnded:Bool = false
    var onDismiss: () -> ()
    
    @State var session:Session?
    
    var body: some View {
        
        VStack{
            if !sessionEnded{
                
                if sessionStarted{
        //                Text(self.session!.duration)
                        Text("Session has started")
        //                Text("SessionID: " + String(self.session?.id))
                        Text("Duration")
                        TimerView(nowDate:Date() , referenceDate:self.session!.start_time)
        //                SessionViewActive(session: $session)
                        Button(action: {self.sessionEnded = true; self.sessionController.endSession()}) {
                            Text("End session")
                        }
                    }
                else{
                    Text("New Session").font(.largeTitle)
                    Text("")
                    Spacer()
                    Button(action: {self.sessionStarted=true;
                        self.session = self.sessionController.startSession()}) {
                        Text("Start session")
                    }
                }
        
            }else{
                // Session has ended
                Text("Session has ended")
                Button(action: {self.sessionController.microphoneSensor.playRecordedAudio()}) {
                    Text("Play audio recorded")
                }
                Divider()
                Button(action: {self.sessionController.microphoneSensor.saveRecording()}) {
                    Text("Save the recorded audio")
                }
                Spacer()
                Button(action: {self.onDismiss()}) {
                    Text("Close session")
                }
            }
        }
        
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
