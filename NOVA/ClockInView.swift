//
//  ClockInView.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct ClockInView: View {
    @EnvironmentObject var clockedInTimer : TimerManager
    @State var alert = false
    
    var body: some View {
        NavigationView {
            MapView(alert: $alert)
                .edgesIgnoringSafeArea(.all)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Please enable location access in settings panel."))
                }
            .navigationBarItems(
                leading: ClockInTimeView().environmentObject(clockedInTimer),
                trailing: clockInButton)
        }
    }
    
    var clockInButton: some View {
        Button(action: {
            self.clockedInTimer.toggle()
        }) {
                HStack {
                        Text(clockedInTimer.mode == .stopped ? "Clock-in" : "Clock-out")
                            .font(.headline)
                            .fontWeight(.bold)
                        Image(systemName: "clock")
                }
                .padding(10)
            }
            .background(Color.white)
            .cornerRadius(10)
            .opacity(0.9)
    }
}

struct ClockInView_Previews: PreviewProvider {
    static var previews: some View {
        ClockInView().environmentObject(TimerManager())
    }
}
