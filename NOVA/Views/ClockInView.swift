//
//  ClockInView.swift
//  NOVA
//
//  Created by pnovacov on 7/19/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import MapKit.MKUserLocation

struct ClockInView: View {
    @EnvironmentObject var locationManager : LocationManager
    @State var alert = false
    @State var showSheet = false
    @State var trackingMode: MKUserTrackingMode = .none
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .trailing) {
                MainMapView(userTrackingMode: $trackingMode)
                    .edgesIgnoringSafeArea(.all)
                    .alert(isPresented: $alert) {
                        Alert(title: Text("Please enable location access in settings panel."))
                    }
                VStack {
                    Spacer()
                    Button(action: {self.trackingMode = .follow}) {
                        Image(systemName: "location.fill")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color(.white))
                            .clipShape(Circle())
                    }
                    
                }
                .padding()
                .padding(.bottom, 20)
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

fileprivate struct MapButton: ViewModifier {
    
    let backgroundColor: Color
    var fontColor: Color = Color(UIColor.systemBackground)
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(self.backgroundColor.opacity(0.9))
            .foregroundColor(self.fontColor)
            .font(.title)
            .clipShape(Circle())
    }
    
}

struct ClockInView_Previews: PreviewProvider {
    static var previews: some View {
        ClockInView().environmentObject(TimerManager()).environmentObject(LocationManager())
    }
}
