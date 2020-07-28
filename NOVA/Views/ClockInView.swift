//
//  ClockInView.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI

struct ClockInView: View {
    @EnvironmentObject var locationManager : LocationManager
    @State var alert = false
    @State var showSheet = false
    
    var body: some View {
        NavigationView {
            MainMapView()
                .edgesIgnoringSafeArea(.all)
                .alert(isPresented: $alert) {
                    Alert(title: Text("Please enable location access in settings panel."))
                }
            .navigationBarItems(
                leading: TimerView().environmentObject(locationManager),
                trailing: clockInButton)
        }.environmentObject(locationManager)
    }
    
    var clockInButton: some View {
        Button(action: {
            self.locationManager.toggle()
            
            if self.locationManager.mode == .stopped {
                self.showSheet = true
            }
        }) {
                HStack {
                        Text(locationManager.mode == .stopped ? "Clock-in" : "Clock-out")
                            .font(.headline)
                            .fontWeight(.bold)
                        Image(systemName: "clock")
                }
                .padding(10)
            }
        .sheet(isPresented: $showSheet, onDismiss: {
            self.locationManager.reset()
        }) {
            RouteView(show: self.$showSheet,locations: self.locationManager.locationList, distance: self.locationManager.distance, totalTime: self.locationManager.seconds)
        }
            .background(Color.white)
            .cornerRadius(10)
            .opacity(0.9)
    }
}

struct ClockInView_Previews: PreviewProvider {
    static var previews: some View {
        ClockInView().environmentObject(TimerManager()).environmentObject(LocationManager())
    }
}
