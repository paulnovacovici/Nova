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
    @Published var status: CLAuthorizationStatus?
    @Published var seconds = 0
    @Published var mode: TrackingMode = .stopped
    
    var locationManager = CLLocationManager()
    var locationList : [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    var timer = Timer()
    
    enum TrackingMode {
        case running
        case stopped
    }
  
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()
    }
    
    func reset() {
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList = []
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
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        mode = .stopped
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            return
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
