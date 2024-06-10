import Dependencies
import CoreLocation
import Foundation
import DependenciesMacros

public struct LocationClient: DependencyKey, Sendable {
    public typealias GetCurrentLocation = @Sendable () throws -> Result<LocationCoordinates2D, LocationError>
    public typealias RequestAuthorization = @Sendable () throws -> Result<EquatableVoid, LocationError>
    
    public var getCurrentLocation: GetCurrentLocation
    public var requestAuthorization: RequestAuthorization
}

public struct EquatableVoid: Equatable, Sendable {}
