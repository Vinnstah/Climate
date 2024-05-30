import Dependencies
import CoreLocation
import Foundation

extension LocationClient {
    
    public static let liveValue: LocationClient = {
        
        let manager = LocationManager()
        
        return .init(
            getCurrentLocation: {
                manager.checkLocationAuthorization()
                guard let location = manager.lastKnownLocation else {
                    throw LocationError.failedToGetCurrentLocation
                }
                return location
            }, requestAuthorization: {
                manager.requestAuthorization()
                
                return .success(EquatableVoid())
            })
    }()
}

//extension LocationClient: TestDependencyKey {
//    static let unimplementedLocationClient = LocationClient()
//  static let testValue = APIClient()
//}

public enum LocationError: Error, Equatable {
    case locationTrackingUnauthorized
    case failedToGetCurrentLocation
}
