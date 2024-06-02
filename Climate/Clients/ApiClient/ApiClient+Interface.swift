import Dependencies
import Foundation
import DependenciesMacros
import CoreLocation

@DependencyClient
public struct ApiClient: Sendable, DependencyKey {
    
    public typealias CurrentWeatherData = @Sendable (CLLocationCoordinate2D, TemperatureUnits?) async throws -> Weather
    public typealias CoordinatesByLocation = @Sendable (Location, StateLocation?) async throws -> [SearchResult]
    
    public var currentWeatherData: CurrentWeatherData
    public var coordinatesByLocation: CoordinatesByLocation
    
}
