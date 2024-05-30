import Dependencies
import CoreLocation
import Foundation
import DependenciesMacros

@DependencyClient
public struct LocationClient: DependencyKey {
    public typealias GetCurrentLocation = @Sendable () throws -> Result<CLLocationCoordinate2D, LocationError>
    public typealias RequestAuthorization = @Sendable () throws -> Result<EquatableVoid, LocationError>
    
    public let getCurrentLocation: GetCurrentLocation
    public let requestAuthorization: RequestAuthorization
}

public struct EquatableVoid: Equatable {}
