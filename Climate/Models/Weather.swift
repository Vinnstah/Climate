import Foundation

public struct Weather: Decodable {
    let coordinates: Coordinates
    let temperature: Temperature
    let currentWeather: [CurrentWeather]
    let wind: Wind
    let rain: Rain
    let clouds: Clouds
    
    public enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case temperature = "main"
        case currentWeather = "weather"
        case wind
        case rain
        case clouds
    }
    
    public struct Coordinates: Equatable, Codable {
        let lat: Double
        let lon: Double
    }
    
    public struct Temperature: Equatable, Codable {
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
            case pressure
            case humidity
        }
    }
    
    public struct CurrentWeather: Codable, Equatable {
        let id: UInt16
        let condition: String
        let description: String
        let icon: String
        
        public enum CodingKeys: String, CodingKey {
            case id
            case condition = "main"
            case description
            case icon
        }
    }
    
    public struct Wind: Equatable, Codable {
        let speed: Double
        let direction: UInt16
        
        public enum CodingKeys: String, CodingKey {
            case speed
            case direction = "deg"
        }
    }
    
    public struct Rain: Equatable, Codable {
        let nextHour: Double
        
        public enum CodingKeys: String, CodingKey {
            case nextHour = "1h"
        }
    }
    
    public struct Clouds: Equatable, Codable {
        let coverage: UInt8
        
        public enum CodingKeys: String, CodingKey {
            case coverage = "all"
        }
    }
}

public enum TemperatureUnits: String {
    case metric
    case imperical
}
