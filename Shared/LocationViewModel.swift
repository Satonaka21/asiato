import CoreLocation
import MapKit
import SwiftUI

// 位置情報の取得など
class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    @Published public var region = MKCoordinateRegion()
    
    private var authorizationStatus: CLAuthorizationStatus
    private var lastSeenLocation: CLLocation?
    
    override init() {
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.last
    }
    
    func getLocation () -> CLLocationCoordinate2D{
        var clLocation = CLLocationCoordinate2D()
        if let location = locationManager.location {
            clLocation = CLLocationCoordinate2D(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
        }
        return clLocation
    }
}

