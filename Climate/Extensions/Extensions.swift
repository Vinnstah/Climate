import CoreLocation
import Foundation
import SwiftUI


extension Double {
    func roundedNumberFormatted() -> String {
        return self.formatted(.number.rounded(increment: 1))
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        (lhs.latitude, lhs.longitude) == (rhs.latitude, rhs.longitude)
    }
}

extension Color {
    public static let primaryColor: Self = {
        Color("PrimaryColor")
    }()
    
    public static let backgroundColor: Self = {
        Color("BackgroundColor")
    }()
    
    public static let accentColor: Self = {
        Color("AccentColor")
    }()
}

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.latitude)
        hasher.combine(self.longitude)
    }
}

extension URL {
    static let openWeather: Self = {
        URL(string: "https://api.openweathermap.org/")!
    }()
}

//extension CLLocationCoordinate2D: Decodable {
//    public enum CodingKeys: CodingKey {
//        case latitude, longitude
//    }
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        
//        self.init()
//        
//        latitude = try values.decode(Double.self, forKey: .latitude)
//        longitude = try values.decode(Double.self, forKey: .longitude)
//    }
//}
