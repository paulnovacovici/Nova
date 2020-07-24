//
//  MapView.swift
//  NOVA
//
//  Created by pnovacov on 7/20/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let manager = CLLocationManager()
    let mapView = MKMapView()
    
    @Binding var alert : Bool
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        
        startLocationUpdates(context)
        
        return mapView
    }
    
    func startLocationUpdates(_ context: Context) {
        // TODO: figure out if when in use means background also
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
        
        manager.delegate = context.coordinator
        manager.distanceFilter = 10
        manager.startUpdatingLocation()
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
        var parent: MapView
        var locationList : [CLLocation] = []
        var distance = Measurement(value: 0, unit: UnitLength.meters)
        
        init(parent: MapView) {
            self.parent = parent
        }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .denied {
                parent.alert.toggle()
            } else if status == .authorizedWhenInUse {
                self.parent.mapView.userTrackingMode = .follow
                self.parent.manager.startUpdatingLocation()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            for location in locations {
                let howRecent = location.timestamp.timeIntervalSinceNow
                
                // Check that the accuracy of the location is with in 20m
                // and that the data is recent
                guard location.horizontalAccuracy < 20 && abs(howRecent) < 10 else {continue}
                
                if let lastLocation = self.locationList.last {
                    let delta = location.distance(from: lastLocation)
                    distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                    let coordinates = [lastLocation.coordinate, location.coordinate]
                    
                    self.parent.mapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2), level: .aboveRoads)
                }
                
                locationList.append(location)
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
              return MKOverlayRenderer(overlay: overlay)
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3
            return renderer
        }
        
        
        
    }
}

struct MapView_Previews: PreviewProvider {
    @State static var manager = CLLocationManager()
    @State static var alert = false
    
    static var previews: some View {
        MapView(alert: self.$alert)
    }
}
