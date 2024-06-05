import Dependencies
import Foundation
import DependenciesMacros
import CoreLocation

@DependencyClient
public struct ApiClient: Sendable, DependencyKey {
    
    public typealias CurrentWeatherAt = @Sendable (CLLocationCoordinate2D, TemperatureUnits?) async throws -> Weather
    public typealias CoordinatesByLocationName = @Sendable (Location.PostalAddress) async throws -> [Location]
    public typealias FiveDayForecast = @Sendable (Location) async throws -> Forecast
    
    public var currentWeatherAt: CurrentWeatherAt
    public var coordinatesByLocationName: CoordinatesByLocationName
    public var fiveDayForecast: FiveDayForecast
    
}
