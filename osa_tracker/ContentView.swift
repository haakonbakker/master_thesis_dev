//
//  ContentView.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 27/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI
import WatchConnectivity


struct ContentView : View {
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        return formatter
    }
    init() {
        
        // Want to set the default wakeup time to 6:30am the next day
        let date: Date = Date().tomorrow!
        let cal: Calendar = Calendar(identifier: .gregorian)
        let newDate: Date = cal.date(bySettingHour: 6, minute: 30, second: 0, of: date)!
        _wakeUpTime = State(initialValue: newDate)
    }
    
    var sessionController = SessionController()
    let sessionData = [SessionController().currentSession]
    @State private var showPopover: Bool = false
    @State private var wakeUpTime:Date
    var body: some View {
        VStack{
            Text("Wake up time").font(.largeTitle)
            VStack{
                DatePicker("Select wake up time", selection: $wakeUpTime, displayedComponents: .hourAndMinute).labelsHidden()
            }
            
            Text("Will wake you up at \(wakeUpTime, formatter: dateFormatter)")
            Button(action: {
                print("New session starting")
                self.showPopover = true
            }) {
                Text("Start").padding(30)
            }.sheet(isPresented: self.$showPopover) {
                SessionView(
                    sessionController: self.sessionController,
                    onDismiss: {self.showPopover = false},
                    session: self.sessionController.startSession(wakeUpTime: self.wakeUpTime)
                )
            }
        }
        
    
    }
}

struct SessionRow : View {
    var session:Session
    
    var body: some View {
        HStack {
            Text(verbatim: session.timestamp)
            Spacer()
            Text(session.duration)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif



// Plan for the day:
// - Create quick outline for application
// - Start working on getting mic on phone to work
// - Make the git repo for this project


