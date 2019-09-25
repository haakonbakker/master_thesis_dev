//
//  SessionView.swift
//  osa_tracker_watch WatchKit Extension
//
//  Created by Haakon W Hoel Bakker on 25/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI

struct SessionWatchView: View {
    var sessionController = SessionController()
    @State var numberOfEvents = 0
    
    @State private var sessionStarted: Bool = false
    @State private var sessionEnded:Bool = false
    
    // Timer to update the view
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.numberOfEvents = self.sessionController.getNumberOfEvents()
        }
    }
    
    var body: some View {
        VStack{
            if(sessionStarted){
                if(sessionEnded){
                    VStack{
                        Text("Session ended").font(.caption)
                    }
                }else{
                    VStack{
                        Text("Active session").font(.caption)
                        HStack{
                            Text("# Events:")
                            Text("\(self.numberOfEvents)").font(.footnote)
                            .onAppear(perform: {
                                _ = self.timer
                            })
                        }
                        Button(action: {
                            print("End button pressed");
                            self.sessionEnded = true;
                            self.sessionController.endSession()
                        }) {
                            Text("End session")
                        }
                    }
                }
                
            }else{
                Text("Watch ready").font(.caption)
                Button(action: {
                    print("Start button pressed");
                    self.sessionStarted = true;
                    self.sessionController.startSession(wakeUpTime: Date());
                }) {
                    Text("Start session")
                }
            }
        }
        
        
        
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionWatchView()
    }
}
