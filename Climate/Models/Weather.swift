import Foundation

public enum TemperatureUnits: String {
    case metric
    case imperical
}



public struct Weather: Decodable {
    let coordinates: Coordinates
    let temperature: Temperature
    let currentWeather: [CurrentWeather]
    let wind: Wind
    
    public enum CodingKeys: String, CodingKey {
        case coordinates = "coord"
        case temperature = "main"
        case currentWeather = "weather"
        case wind
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
    //      "visibility": 10000,
    //      "wind": {
    //        "speed": 0.62,
    //        "deg": 349,
    //        "gust": 1.18
    //      },
    //      "rain": {
    //        "1h": 3.16
    //      },
    //      "clouds": {
    //        "all": 100
    //      },
    //      "dt": 1661870592,
    //      "sys": {
    //        "type": 2,
    //        "id": 2075663,
    //        "country": "IT",
    //        "sunrise": 1661834187,
    //        "sunset": 1661882248
    //      },
    //      "timezone": 7200,
    //      "id": 3163858,
    //      "name": "Zocca",
    //      "cod": 200
    //    }
}
