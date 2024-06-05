import Foundation

public struct Weather: Decodable, Equatable, Sendable {
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
    
    public struct Coordinates: Equatable, Codable, Sendable {
        let lat: Double
        let lon: Double
    }
    
    public struct Temperature: Equatable, Codable, Sendable {
        let temp: Double
        let feelsLike: Double
        let minTemp: Double
        let maxTemp: Double
        let pressure: UInt32
        let humidity: UInt8
        
        public enum CodingKeys: String, CodingKey {
            case temp = "temp"
            case feelsLike = "feels_like"
            case minTemp = "temp_min"
            case maxTemp = "temp_max"
            case pressure, humidity
        }
    }
    
    public struct CurrentWeather: Codable, Equatable, Sendable {
        let id: UInt16
        let condition: String
        let description: String
        let icon: String
        
        public enum CodingKeys: String, CodingKey {
            case id, icon, description
            case condition = "main"
        }
    }
    
    public struct Wind: Equatable, Codable, Sendable {
        let speed: Double
        let direction: UInt16
        
        public enum CodingKeys: String, CodingKey {
            case speed
            case direction = "deg"
        }
    }
    
    public struct Rain: Equatable, Codable, Sendable {
        let nextHour: Double
        
        public enum CodingKeys: String, CodingKey {
            case nextHour = "1h"
        }
    }
    
    public struct Clouds: Equatable, Codable, Sendable {
        let coverage: UInt8
        
        public enum CodingKeys: String, CodingKey {
            case coverage = "all"
        }
    }
}

extension Weather {
    static let mock: Self = Weather(
        coordinates: Coordinates(
            lat: 12.123,
            lon: 12.123
        ),
        temperature: Temperature(
            temp: 22.1,
            feelsLike: 24.2,
            minTemp: 18.2,
            maxTemp: 26.5,
            pressure: 1560,
            humidity: 60
        ),
        currentWeather: [CurrentWeather(
            id: 12345,
            condition: "Sun",
            description: "Sun",
            icon: "01d"
        )],
        wind: Wind(
            speed: 12.2,
            direction: 256
        ),
        rain: nil,
        clouds: Clouds(coverage: 44)
    )
}
