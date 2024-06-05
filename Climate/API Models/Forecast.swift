import Foundation

public struct Forecast: Decodable, Equatable, Sendable {
    public let cod: String
    public let message, cnt: Int
    public let list: [Weather]
    public let city: City
}

public struct City: Codable, Equatable, Sendable {
    public let id: Int
    public let name: String
//    public let coord: /*Weather.Coordinates*/
    public let country: String
    public let population, timezone, sunrise, sunset: Int
}
