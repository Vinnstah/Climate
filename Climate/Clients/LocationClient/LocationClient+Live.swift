import Dependencies
import CoreLocation
import Foundation

extension LocationClient {
    
    static let liveValue: LocationClient = {
        
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        
        return .init(
            getCurrentLocation: {
                guard locationManager.authorizationStatus == .authorizedAlways else {
                    throw LocationError.locationTrackingUnauthorized
                }
                guard let location = locationManager.location else {
                    throw LocationError.failedToGetCurrentLocation
                }
                return location
            })
    }()
}

enum LocationError: Error {
    case locationTrackingUnauthorized
    case failedToGetCurrentLocation
}
