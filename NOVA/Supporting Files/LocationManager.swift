//
//  LocationManager.swift
//  NOVA
//
//  Created by pnovacov on 7/25/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import CoreLocation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject {
//    static let shared = LocationManager()
    
    @Published var status: CLAuthorizationStatus?
    @Published var seconds = 0
    @Published var mode: TrackingMode = .stopped
    
    var manager = CLLocationManager()
    var delegate: MKMapView?
    var locationList : [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var timer = Timer()
    
    enum TrackingMode {
        case running
        case stopped
    }
  
    override init() {
        super.init()
        
        manager.delegate = self
        manager.distanceFilter = 10
        manager.requestWhenInUseAuthorization()
    }
    
    func toggle() {
        if mode == .running {
            stop()
        } else {
            start()
        }
    }
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.seconds += 1
        }
        // TODO: need to test what happens when start is called and status is denied
        manager.startUpdatingLocation()
    }
    
    func stop() {
        mode = .stopped
        timer.invalidate()
        manager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        
        if status == .authorizedWhenInUse {
            delegate?.userTrackingMode = .follow
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            let howRecent = location.timestamp.timeIntervalSinceNow
            
            // Check that the accuracy of the location is with in 20m
            // and that the data is recent
            guard location.horizontalAccuracy < 20 && abs(howRecent) < 10 else {continue}
            
            if let lastLocation = locationList.last {
                let delta = location.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            }
            
            locationList.append(location)
        }
    }
}
