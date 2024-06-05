import Foundation

public struct PostalAddress: Equatable {
    let stateCode: String
    let countryCode: String
    let city: String
    
    func formattedString() -> String {
        switch self.stateCode.isEmpty {
        case true:
            return "\(self.city),\(self.countryCode)"
        case false:
            return "\(self.city),\(self.stateCode),\(self.countryCode)"
        }
    }
    
    init(location: Location, stateCode: String) {
        self.city = location.city
        self.countryCode = location.countryCode
        self.stateCode = stateCode
    }
}
