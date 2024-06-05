import Dependencies
import Foundation
import DependenciesMacros

@DependencyClient
public struct WeatherClient: Sendable, DependencyKey {
    
    public typealias CurrentWeatherAt = @Sendable (CurrentWeatherRequest) async throws -> WeatherAtLocation
    public typealias LocationsFromPostalAddress = @Sendable (PostalAddress) async throws -> [GeoLocation]
    public typealias FiveDayForecast = @Sendable (GeoLocation) async throws -> Forecast
    
    public var currentWeatherAt: CurrentWeatherAt
    public var locationsfromPostalAddress: LocationsFromPostalAddress
    public var fiveDayForecast: FiveDayForecast
}
