import Foundation

public struct Location: Equatable, Codable {
    var city: String
    var countryCode: String
}

public struct StateLocation: Equatable, Codable {
    var state: String
}

public struct SearchResult: Equatable, Codable, Hashable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
}
