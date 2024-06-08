import Foundation
import CoreLocation

public typealias LocationCoordinates2D = CLLocationCoordinate2D

public enum TemperatureUnits: String, Sendable, Hashable, CaseIterable {
    case metric
    case imperial
    
    var description: String {
        switch self {
        case .metric: return "°C"
        case .imperial: return "F"
        }
    }
}

public struct CurrentWeatherRequest: Equatable {
    let location: GeoLocation
    let temperatureUnits: TemperatureUnits?
    
    public init(location: GeoLocation, temperatureUnits: TemperatureUnits?) {
        self.temperatureUnits = temperatureUnits
        self.location = location
    }
}

public struct WeatherAtLocation: Equatable, Sendable {
    let temperature: CurrentTemperature
    let postalAddress: PostalAddress
    let wind: Double
    let conditions: Conditions
    
    public init(
        weather: Weather,
        location: GeoLocation
    ) {
        self.temperature = CurrentTemperature(
            temp: weather.temperature.feelsLike,
            feelsLike: weather.temperature.feelsLike,
            humidity: weather.temperature.humidity
        )
        self.postalAddress = PostalAddress(geoLocation: location)
        self.wind = weather.wind.speed
        self.conditions = Conditions(weather: weather.currentWeather.first!)
    }
    
    internal init(
        temperature: CurrentTemperature,
        postalAddress: PostalAddress,
        wind: Double,
        conditions: Conditions
    ) {
        self.temperature = temperature
        self.postalAddress = postalAddress
        self.wind = wind
        self.conditions = conditions
    }
    
    public static let empty: Self = {
        Self.init(weather: .preview, location: .empty)
    }()
}

public struct CurrentTemperature: Equatable, Sendable {
    let temp: Double
    let feelsLike: Double
    let humidity: UInt8
    
    public static let preview: Self = {
        Self.init(
            temp: 24,
            feelsLike: 26,
            humidity: 45
        )
    }()
}

public struct Conditions: Equatable, Sendable {
    let description: String
    let image: String
    
    public init(weather: Weather.CurrentWeather) {
        self.description = weather.description
        self.image = weather.icon
    }
    
    internal init(description: String, image: String) {
        self.description = description
        self.image = image
    }
    
    public static let preview: Self = {
        Self.init(description: "Sun", image: "01d")
    }()
}

extension WeatherAtLocation {
    public static let preview: Self = {
        Self.init(
            temperature: .preview,
            postalAddress: .preview,
            wind: 5,
            conditions: .preview
        )
    }()
}
