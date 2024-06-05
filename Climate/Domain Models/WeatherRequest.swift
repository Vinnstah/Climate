import Foundation
import CoreLocation

public typealias LocationCoordinates2D = CLLocationCoordinate2D

public enum TemperatureUnits: String {
    case metric
    case imperial
    
    var description: String {
        switch self {
        case .metric: return "°C"
        case .imperial: return "F"
        }
    }
}
