import Dependencies
import CoreLocation
import Foundation
import DependenciesMacros

public struct LocationClient: DependencyKey {
    public typealias GetCurrentLocation = @Sendable () throws -> Result<LocationCoordinates2D, LocationError>
    public typealias RequestAuthorization = @Sendable () throws -> Result<EquatableVoid, LocationError>
    
    public let getCurrentLocation: GetCurrentLocation
    public let requestAuthorization: RequestAuthorization
}

public struct EquatableVoid: Equatable, Sendable {}
