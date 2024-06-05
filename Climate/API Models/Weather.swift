import Foundation
import CoreLocation

public struct Weather: Codable, Equatable, Sendable {
    let coordinates: Coordinates
    let temperature: Temperature
    let currentWeather: [CurrentWeather]
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    
    public enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case temperature = "main"
        case currentWeather = "weather"
        case wind, rain, clouds
    }
    
    public struct Temperature: Codable, Equatable, Sendable {
        let temp: Double
        let feelsLike: Double
        let minTemp: Double
        let maxTemp: Double
        let pressure: UInt32
        let humidity: UInt8
        
        public enum CodingKeys: String, CodingKey {
            case feelsLike = "feels_like"
            case minTemp = "temp_min"
            case maxTemp = "temp_max"
            case temp, pressure, humidity
        }
    }
    
    public struct CurrentWeather: Codable, Equatable, Sendable {
        let id: UInt16
        let condition: String
        let description: String
        let icon: String
        
        public enum CodingKeys: String, CodingKey {
            case condition = "main"
            case id, description, icon
        }
    }
    public struct Wind: Codable, Equatable, Sendable {
        let speed: Double
        let direction: UInt16
        
        public enum CodingKeys: String, CodingKey {
            case speed
            case direction = "deg"
        }
    }
    public struct Rain: Codable, Equatable, Sendable {
        let nextHour: Double
        
        public enum CodingKeys: String, CodingKey {
            case nextHour = "1h"
        }
    }
    
    public struct Clouds: Codable, Equatable, Sendable {
        let coverage: UInt8
        
        public enum CodingKeys: String, CodingKey {
            case coverage = "all"
        }
    }
}

public struct Coordinates: Equatable, Codable, Sendable {
    let lat: Double
    let lon: Double
    
    public init(coordinates: CLLocationCoordinate2D) {
        self.lat = coordinates.latitude
        self.lon = coordinates.longitude
    }
    
    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
    
    static let preview: Self = {
        Self.init(
            lat: 59.334591,
            lon: 18.063240
        )
    }()
}

extension Weather.Temperature {
    static let preview: Self = {
        Self.init(
            temp: 24,
            feelsLike: 26,
            minTemp: 17,
            maxTemp: 29,
            pressure: 42,
            humidity: 50
        )
    }()
}

extension Weather.CurrentWeather {
    static let preview: Self = {
        Self.init(
            id: 1234,
            condition: "Sun",
            description: "Sunny",
            icon: "01d"
        )
    }()
}

extension Weather.Clouds {
    static let preview: Self = {
        Self.init(coverage: 50)
    }()
}

extension Weather.Rain {
    static let preview: Self = {
        Self.init(nextHour: 12)
    }()
}
extension Weather.Wind {
    static let preview: Self = {
        Self.init(speed: 5, direction: 254)
    }()
}

extension Weather {
    static let preview: Self = {
        Self.init(
            coordinates: .preview,
            temperature: .preview,
            currentWeather: [.preview],
            wind: .preview,
            rain: .preview,
            clouds: .preview
        )
    }()
}
