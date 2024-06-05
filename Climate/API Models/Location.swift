import Foundation
import MetaCodable

public struct Location: Hashable, Codable {
    @CodedAt("name")
    let city: String
    @CodedAt("lat")
    let latitude: Double
    @CodedAt("lon")
    let longitude: Double
    @CodedAt("country")
    let countryCode: String
    let state: String
}
