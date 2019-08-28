//
//  ContentView.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 27/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI

struct ContentView : View {

    let sessionController = SessionController()
    let sessionData = SessionController().getSessions()
    @State private var showPopover: Bool = false
    var body: some View {
        VStack{
            NavigationView{
                List(sessionData) { ses in
                    NavigationLink(destination: SessionDetailView()) {
                        SessionRow(session: ses)
                    }
                    
                }.onAppear(perform: {print("Will get some data")})
                .navigationBarTitle(Text("Sleep Sessions"))
                .navigationBarItems(trailing:
                    Button(action: {
                        print("New session starting")
                        self.showPopover = true
                    }) {
                        Text("+ Session")
                    }
                ).popover(
                    isPresented: self.$showPopover,
                    arrowEdge: .bottom
                    ) { SessionView(sessionController: SessionController()) }

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


