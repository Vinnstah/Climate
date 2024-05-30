import Dependencies
import CoreLocation
import Foundation
import DependenciesMacros

@DependencyClient
public struct LocationClient {
    public typealias GetCurrentLocation = @Sendable () throws -> CLLocation
    
    public let getCurrentLocation: GetCurrentLocation
}
