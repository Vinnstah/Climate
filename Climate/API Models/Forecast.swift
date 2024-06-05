import Foundation

public struct Forecast: Codable, Equatable, Sendable {
    public let cod: String?
    public let message, cnt: Int?
    public let list: [ForecastWeather]?
    public let city: City?
}

public struct City: Codable, Equatable, Sendable {
    public let id: Int?
    public let name: String?
    public let coord: Coord?
    public let country: String?
    public let population, timezone, sunrise, sunset: Int?
}

public struct Coord: Codable, Equatable, Sendable {
    public let lat, lon: Double?
}

public struct ForecastWeather: Codable, Equatable, Sendable {
    public let dt: Int?
    public let main: Temp?
    public let weather: [WeatherForecast]?
    public let clouds: Clouds?
    public let wind: Wind?
    public let visibility: Int?
    public let pop: Double?
    public let rain: Rain?
    public let sys: Sys?
    public let dtTxt: String?

    public enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

public struct Clouds: Codable, Equatable, Sendable {
    public let all: Int?
}

public struct Temp: Codable, Equatable, Sendable {
    public let temp, feelsLike, tempMin, tempMax: Double?
    public let pressure, seaLevel, grndLevel, humidity: Int?
    public let tempKf: Double?

    public enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

public struct Rain: Codable, Equatable, Sendable {
    public let the3H: Double?

    public enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

public struct Sys: Codable, Equatable, Sendable {
    public let pod: String?

    public init(pod: String?) {
        self.pod = pod
    }
}

public struct WeatherForecast: Codable, Equatable, Sendable {
    public let id: Int?
    public let main, description, icon: String?

}

public struct Wind: Codable, Equatable, Sendable {
    public let speed: Double?
    public let deg: Int?
    public let gust: Double?
}
