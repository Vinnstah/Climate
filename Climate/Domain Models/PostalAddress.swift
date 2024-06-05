import Foundation

public struct PostalAddress: Equatable {
    let countryCode: String
    let city: String
    
    public init(location: GeoLocation) {
        self.city = location.city
        self.countryCode = location.country
    }
    
    internal init(
        countryCode: String,
        city: String
    ) {
        self.countryCode = countryCode
        self.city = city
    }
    
    public static let preview: Self = {
        Self.init(countryCode: "SE", city: "Stockholm")
    }()
}

public struct PostalAddressRequest: Equatable {
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
    
    public init(
        address: PostalAddress,
        stateCode: String
    ) {
        self.city = address.city
        self.countryCode = address.countryCode
        self.stateCode = stateCode
    }
}


public struct GeoLocation: Hashable, Sendable {
    let coordinates: LocationCoordinates2D
    var city: String
    var country: String
    
    public init(location: Location) {
        self.coordinates = LocationCoordinates2D(
            latitude: location.latitude,
            longitude: location.longitude
        )
        self.city = location.city
        self.country = location.countryCode
    }
    
    public init(address: PostalAddress, location: LocationCoordinates2D) {
        self.coordinates = location
        self.city = address.city
        self.country = address.countryCode
    }
    
    public init(location: LocationCoordinates2D) {
        self.coordinates = location
        self.city = "Current Location"
        self.country = ""
    }
    
    static let empty: Self = {
        Self.init(address: .init(countryCode: "", city: ""), location: .init())
    }()
}
