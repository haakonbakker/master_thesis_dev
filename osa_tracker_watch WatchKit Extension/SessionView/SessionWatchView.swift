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
    
    // Timer to update the view
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.numberOfEvents = self.sessionController.getNumberOfEvents()
        }
    }
    
    var body: some View {
        VStack{
            Text("This is the session")
            HStack{
                Text("# Events:")
                Text("\(self.numberOfEvents)").font(.footnote)
                .onAppear(perform: {
                    _ = self.timer
                })
            }
            Button(action: {
                print("Test button pressed");
                self.sessionController.startSession(wakeUpTime: Date());
            }) {
                Text("Test button")
            }
        }
        
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionWatchView()
    }
}
