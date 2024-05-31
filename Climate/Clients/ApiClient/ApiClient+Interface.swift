import Dependencies
import Foundation
import DependenciesMacros
import CoreLocation

@DependencyClient
public struct ApiClient: Sendable, DependencyKey {
    
    public typealias CurrentWeatherData = @Sendable (CLLocationCoordinate2D, TemperatureUnits?) async throws -> Weather
    
    public let currentWeatherData: CurrentWeatherData
    
}

