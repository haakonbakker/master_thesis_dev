//
//  ContentView.swift
//  osa_tracker_watch WatchKit Extension
//
//  Created by Haakon W Hoel Bakker on 25/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @State private var showSessionWatchView: Bool = false
    
    
    init(){
        print("\(#function)")
    }
    
    var body: some View {
        VStack{
            
            Text("Sleep tracker").font(.caption)
            Text("Waking up at 06:30am").font(.subheadline)
            Button(action: {
                print("Go to sleep button pressed");
                self.showSessionWatchView = true
            }) {
                Text("Go to sleep")
            }.sheet(isPresented: self.$showSessionWatchView){
                SessionWatchView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
