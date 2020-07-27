//
//  RouteView.swift
//  NOVA
//
//  Created by pnovacov on 7/26/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import MapKit

struct RouteView: View {
    @Binding var show : Bool
    
    var locations : [CLLocation]
    var distance : Measurement<UnitLength>
    var totalTime : Int
    
    var body: some View {
        NavigationView {
            RouteMapView(locations: locations, distance: distance, totalTime: totalTime)
                .navigationBarTitle(Text("Route Overview"), displayMode: .inline)
                .navigationBarItems(trailing: doneButton)
        }
    }
    
    var doneButton: some View {
        Button(action: {
            self.show = false
        }) {
            Text("Done").bold()
        }
    }
}

//struct RouteView_Previews: PreviewProvider {
//    static var previews: some View {
//        RouteView()
//    }
//}
