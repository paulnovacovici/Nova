//
//  MapView.swift
//  NOVA
//
//  Created by pnovacov on 7/20/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import MapKit


struct MainMapView: UIViewRepresentable {
    @EnvironmentObject var manager : LocationManager
        
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.setUserTrackingMode(.follow, animated: true)
        manager.delegate = mapView
        
        return mapView
    }
    
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
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

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
