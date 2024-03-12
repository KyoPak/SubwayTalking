//
//  LocationManager.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/11/24.
//

import CoreLocation

protocol LocationAccessable: AnyObject {
    func requestLocationAuthorization()
    func updateLocation(latitude: Double, longitude: Double)
}

final class LocationManager: NSObject {
    private var locationManager: CLLocationManager?
    weak var delegate: LocationAccessable?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func checkAuthority() -> Bool {
        switch locationManager?.authorizationStatus {
        case .denied, .notDetermined, .restricted:
            delegate?.requestLocationAuthorization()
            return false
        default:
            return true
        }
    }
    
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .restricted, .notDetermined: 
            delegate?.requestLocationAuthorization()
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last?.coordinate else { return }
        
        delegate?.updateLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
    }
}
