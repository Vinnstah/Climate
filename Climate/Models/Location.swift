import Foundation
import CoreLocation

public struct Location: Equatable {
    var city: String
    var location: CLLocationCoordinate2D?
    var countryCode: String
    var stateCode: String
    
    func formattedString() -> String {
        switch self.stateCode.isEmpty {
        case true:
            return "\(self.city),\(self.countryCode)"
        case false:
            return "\(self.city),\(stateCode),\(self.countryCode)"
        }
    }
}

extension Location {
    static let empty: Self = {
        Self.init(
            city: "",
            location: .init(),
            countryCode: "",
            stateCode: ""
        )
    }()
}
public struct SearchResult: Equatable, Codable, Hashable {
    let name: String
    let lat: Double
    let lon: Double
    let state: String?
    let country: String
    
    public enum CodingKeys: String, CodingKey {
        case name, lat, lon, country, state
    }
}
