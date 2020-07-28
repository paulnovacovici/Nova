//
//  RouteMapView.swift
//  NOVA
//
//  Created by pnovacov on 7/26/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import SwiftUI
import MapKit


struct RouteMapView: UIViewRepresentable {
    var locations : [CLLocation]
    var distance : Measurement<UnitLength>
    var totalTime : Int
    
        
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        loadMap(mapView: mapView)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        
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
            renderer.lineWidth = 4
            return renderer
        }
    }
    
    private func loadMap(mapView: MKMapView) {
        guard locations.count > 0, let region = mapRegion()
            else {
                // Figure out how to display an alert
                return
        }
        
        mapView.setRegion(region, animated: true)
        mapView.addOverlay(polyLine())
    }
    
    private func mapRegion() -> MKCoordinateRegion? {
      guard
        locations.count > 0
      else {
        return nil
      }
      
      let latitudes = locations.map { location -> Double in
        return location.coordinate.latitude
      }
      
      let longitudes = locations.map { location -> Double in
        return location.coordinate.longitude
      }
      
      let maxLat = latitudes.max()!
      let minLat = latitudes.min()!
      let maxLong = longitudes.max()!
      let minLong = longitudes.min()!
      
      let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                          longitude: (minLong + maxLong) / 2)
      let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                  longitudeDelta: (maxLong - minLong) * 1.3)
      return MKCoordinateRegion(center: center, span: span)
    }
    
    private func polyLine() -> MKPolyline {
      let coords: [CLLocationCoordinate2D] = locations.map { location in
        return location.coordinate
      }
      return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    
//    private func segmentColor(speed: Double, midSpeed: Double, slowestSpeed: Double, fastestSpeed: Double) -> UIColor {
//      enum BaseColors {
//        static let r_red: CGFloat = 1
//        static let r_green: CGFloat = 20 / 255
//        static let r_blue: CGFloat = 44 / 255
//
//        static let y_red: CGFloat = 1
//        static let y_green: CGFloat = 215 / 255
//        static let y_blue: CGFloat = 0
//
//        static let g_red: CGFloat = 0
//        static let g_green: CGFloat = 146 / 255
//        static let g_blue: CGFloat = 78 / 255
//      }
//
//      let red, green, blue: CGFloat
//
//      if speed < midSpeed {
//        let ratio = CGFloat((speed - slowestSpeed) / (midSpeed - slowestSpeed))
//        red = BaseColors.r_red + ratio * (BaseColors.y_red - BaseColors.r_red)
//        green = BaseColors.r_green + ratio * (BaseColors.y_green - BaseColors.r_green)
//        blue = BaseColors.r_blue + ratio * (BaseColors.y_blue - BaseColors.r_blue)
//      } else {
//        let ratio = CGFloat((speed - midSpeed) / (fastestSpeed - midSpeed))
//        red = BaseColors.y_red + ratio * (BaseColors.g_red - BaseColors.y_red)
//        green = BaseColors.y_green + ratio * (BaseColors.g_green - BaseColors.y_green)
//        blue = BaseColors.y_blue + ratio * (BaseColors.g_blue - BaseColors.y_blue)
//      }
//
//      return UIColor(red: red, green: green, blue: blue, alpha: 1)
//    }
//
//    private func polyLine() -> [MulticolorPolyline] {
//        var coordinates: [(CLLocation, CLLocation)] = []
//        var speeds: [Double] = []
//        var minSpeed = Double.greatestFiniteMagnitude
//        var maxSpeed = 0.0
//
//        for (start, end) in zip(locations, locations.dropFirst()) {
//            coordinates.append((start, end))
//
//            let distance = end.distance(from: start)
//            let time = end.timestamp.timeIntervalSince(start.timestamp)
//            let speed = time > 0 ? distance / time : 0
//            speeds.append(speed)
//            minSpeed = min(minSpeed, speed)
//            maxSpeed = max(maxSpeed, speed)
//        }
//
//        let midSpeed = speeds.reduce(0, +) / Double(speeds.count)
//
//        var segments: [MulticolorPolyline] = []
//        for ((start, end), speed) in zip(coordinates, speeds) {
//            let coords = [start.coordinate, end.coordinate]
//            let segment = MulticolorPolyline(coordinates: coords, count: 2)
//            segment.color = segmentColor(speed: speed,
//                                         midSpeed: midSpeed,
//                                         slowestSpeed: minSpeed,
//                                         fastestSpeed: maxSpeed)
//            segments.append(segment)
//        }
//        return segments
//    }
}
