import CoreLocation
import Foundation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    var manager = CLLocationManager()
    
    func requestAuthorization() {
        manager.requestAlwaysAuthorization()
    }
    
    func checkLocationAuthorization() throws {
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .restricted:
            throw LocationError.locationTrackingRestricted
            
        case .denied:
            throw LocationError.locationTrackingDenied
            
        case .authorizedAlways:
            lastKnownLocation = manager.location?.coordinate
            
        case .authorizedWhenInUse:
            lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            throw LocationError.locationServiceDisabled
            
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // TODO: Handle errors
        try? checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}

