//
//  RouteView.swift
//  NOVA
//
//  Created by pnovacov on 7/26/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import MapKit

struct RouteCard: View {
    var distance: Measurement<UnitLength>
    var totalTime: Int
    let distanceFormatter = MeasurementFormatter()
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .brief
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Total Time:")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(secondsToHoursMinutesSeconds(seconds: totalTime))")
            }
            HStack {
                Text("Distance:")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(distanceFormatter.string(for: distance)!)")
            }
        }
        .padding()
        .foregroundColor(.black)
        .background(Color.white)
        .cornerRadius(10)
        .opacity(0.9)
    }
}

struct RouteView: View {
    @Binding var show : Bool
    
    var locations : [CLLocation]
    var distance : Measurement<UnitLength>
    var totalTime : Int
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                RouteMapView(locations: locations, distance: distance, totalTime: totalTime)
                VStack {
                    Spacer()
                    RouteCard(distance: self.distance, totalTime: self.totalTime)
                }
                .padding()
                .padding(.bottom)
            }
            .navigationBarTitle(Text("Route Overview"), displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: submitButton)
        }
    }
    
    var cancelButton: some View {
        Button(action: {
            self.show = false
        }) {
            Text("Cancel").bold()
        }
    }
    
    var submitButton: some View {
        Button(action: {
            // TODO: Send data to database
            self.show = false
        }) {
            Text("Submit").bold()
        }
    }
}

struct RouteView_Previews: PreviewProvider {
    static var locations: [CLLocation] = [];
    static var distance: Measurement<UnitLength> = Measurement(value: 5000, unit: UnitLength.meters)
    static var totalTime: Int = 30103
    @State static var show = true
    
    static var previews: some View {
        RouteView(show: $show, locations: locations, distance: distance, totalTime: totalTime)
    }
}
