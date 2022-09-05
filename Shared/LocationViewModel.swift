import CoreLocation
import MapKit
import SwiftUI

// 位置情報の取得など
class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @State var authorizationStatus: CLAuthorizationStatus
    @State var publishedRegion: MKCoordinateRegion
    @State var lastSeenLocation: CLLocation?
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        self.publishedRegion =  MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 35.0,
                longitude: 135.0
            ),
            latitudinalMeters: 300.0,
            longitudinalMeters: 300.0
        )
        
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
        lastSeenLocation = locations.first
    }
    
    func resetCoordinateRegion() -> MKCoordinateRegion {
        let latitude = lastSeenLocation?.coordinate.latitude ?? 0
        let longitude = lastSeenLocation?.coordinate.longitude ?? 0

        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            latitudinalMeters: 300.0,
            longitudinalMeters: 300.0
        )
    }
}

