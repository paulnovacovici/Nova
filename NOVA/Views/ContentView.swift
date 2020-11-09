//
//  ContentView.swift
//  NOVA
//
//  Created by pnovacov on 6/16/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct App: View {
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
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
            }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        Group {
            if (session.session != nil) {
                App()
            } else {
                AuthView()
            }
        }.onAppear(perform: getUser)
    }
    
    func getUser() {
        session.listen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject((SessionStore()))
    }
}
