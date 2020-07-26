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
    let manager = LocationManager.shared
    let mapView = MKMapView()
        
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        
        manager.delegate = mapView
        
        return mapView
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
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

struct MapView_Previews: PreviewProvider {    
    static var previews: some View {
        MapView()
    }
}
