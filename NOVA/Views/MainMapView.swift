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
    @Binding var userTrackingMode : MKUserTrackingMode
        
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.setUserTrackingMode(.follow, animated: true)
        
        // Zoom to user location
        if let userLocation = manager.locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(viewRegion, animated: true)
        }
        
        return mapView
    }
    
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if mapView.userTrackingMode != userTrackingMode {
            mapView.setUserTrackingMode(userTrackingMode, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MainMapView
        
        init(_ parent: MainMapView) {
            self.parent = parent
            
            super.init()
        }
        
        private func present(_ alert: UIAlertController, animated: Bool = true, completion: (() -> Void)? = nil) {
            // UIApplication.shared.keyWindow has been deprecated in iOS 13,
            // so you need a little workaround to avoid the compiler warning
            // https://stackoverflow.com/a/58031897/10967642
            
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            keyWindow?.rootViewController?.present(alert, animated: animated, completion: completion)
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
        
        /// All credit for this tracking function https://stackoverflow.com/questions/58398437/how-to-add-a-move-back-to-user-location-button-in-swiftui
        /// - Parameters:
        ///   - mapView: map view
        ///   - mode: tracking mode
        ///   - animated: animated flag
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            if CLLocationManager.locationServicesEnabled() {
                switch mode {
                case .follow, .followWithHeading:
                    switch CLLocationManager.authorizationStatus() {
                    case .notDetermined:
                        parent.manager.locationManager.requestWhenInUseAuthorization()
                    case .restricted:
                        // Possibly due to active restrictions such as parental controls being in place
                        let alert = UIAlertController(title: "Location Permission Restricted", message: "The app cannot access your location. This is possibly due to active restrictions such as parental controls being in place. Please disable or remove them and enable location permissions in settings.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                            // Redirect to Settings app
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        })
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

                        present(alert)
                        
                        DispatchQueue.main.async {
                            self.parent.userTrackingMode = .none
                        }
                    case .denied:
                        let alert = UIAlertController(title: "Location Permission Denied", message: "Please enable location permissions in settings.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                            // Redirect to Settings app
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        })
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        present(alert)
                        
                        DispatchQueue.main.async {
                            self.parent.userTrackingMode = .none
                        }
                    default:
                        DispatchQueue.main.async {
                            self.parent.userTrackingMode = mode
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        self.parent.userTrackingMode = mode
                    }
                }
            } else {
                let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services in settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                    // Redirect to Settings app
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alert)
                
                DispatchQueue.main.async {
                    self.parent.userTrackingMode = mode
                }
            }
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
