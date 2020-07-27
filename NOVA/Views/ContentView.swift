//
//  ContentView.swift
//  NOVA
//
//  Created by pnovacov on 6/16/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published var onClockTime = TimerManager()
}

struct ContentView: View {
    var body: some View {
        TabView {
            CheckInView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Check-in")
                }
            
            ClockInView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Clock-in")
            }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("History")
            }
            
            Text("Settings Screen")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
            }
            }.environmentObject(LocationManager())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
