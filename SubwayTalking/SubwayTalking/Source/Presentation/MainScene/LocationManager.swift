//
//  LocationManager.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/11/24.
//

import CoreLocation

import RxSwift

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
    
    func getAddress(location: CLLocation) -> Observable<String> {
        locationManager?.distanceFilter = kCLDistanceFilterNone
        
        let geocoder = CLGeocoder.init()
        
        return Observable<String>.create { observer in
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil { observer.onNext(Constant.Text.converteAddressFail) }
                
                if let placemark = placemarks?.first {
                    var address = ""
                    
                    if let administrativeArea = placemark.administrativeArea {
                        address = "\(address) \(administrativeArea) "
                    }
                    
                    if let locality = placemark.locality {
                        address = "\(address) \(locality) "
                    }
                    
                    if let subLocality = placemark.subLocality {
                        address = "\(address) \(subLocality) "
                    }
                    
                    observer.onNext(address)
                }
            }
            
            return Disposables.create()
        }
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.updateLocation(latitude: .zero, longitude: .zero)
    }
}
