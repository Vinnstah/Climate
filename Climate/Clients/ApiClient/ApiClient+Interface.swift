import Dependencies
import Foundation
import DependenciesMacros
import CoreLocation

@DependencyClient
public struct ApiClient: Sendable, DependencyKey {
    
    public typealias CurrentWeatherAt = @Sendable (CurrentWeatherRequest) async throws -> Weather
    public typealias CoordinatesByLocationName = @Sendable (PostalAddressRequest) async throws -> [Location]
    public typealias FiveDayForecast = @Sendable (GeoLocation) async throws -> Forecast
    
    public var currentWeatherAt: CurrentWeatherAt
    public var coordinatesByLocationName: CoordinatesByLocationName
    public var fiveDayForecast: FiveDayForecast
    
}
