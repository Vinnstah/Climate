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
