import Dependencies
import CoreLocation
import Foundation

extension LocationClient {
    
    public static let liveValue: LocationClient = {
        
        let manager = LocationManager()
        
        return .init(
            getCurrentLocation: {
                try manager.checkLocationAuthorization()
                
                guard let location = manager.lastKnownLocation else {
                    throw LocationError.failedToGetLastKnownLocation
                }
                
                return .success(location)
                
            }, requestAuthorization: {
                manager.requestAuthorization()
                
                return .success(EquatableVoid())
            })
    }()
}

extension LocationManager: @unchecked Sendable  {}

extension LocationClient: TestDependencyKey {
    public static let testValue = Self(
        getCurrentLocation: unimplemented("LocationClient.getCurrentLocation"),
        requestAuthorization: unimplemented("LocationClient.requestAuthorization"))
}

extension DependencyValues {
    public var locationClient: LocationClient {
        get { self[LocationClient.self] }
        set { self[LocationClient.self] = newValue }
    }
}
