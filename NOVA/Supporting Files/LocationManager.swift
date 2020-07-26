//
//  LocationManager.swift
//  NOVA
//
//  Created by pnovacov on 7/25/20.
//  Copyright © 2020 Nova. All rights reserved.
//

import CoreLocation
import MapKit


class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    
    @Published var status: CLAuthorizationStatus?
    @Published var clockedInTimer = TimerManager()
    
    var manager = CLLocationManager()
    var delegate: MKMapView?
    var locationList : [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
  
    private override init() {
        super.init()
        
        manager.delegate = self
        manager.distanceFilter = 10
        manager.requestWhenInUseAuthorization()
    }
    
    func start() {
        // TODO: need to test what happens when start is called and status is denied
        clockedInTimer.toggle()
        manager.startUpdatingLocation()
    }
    
    func stop() {
        clockedInTimer.toggle()
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
