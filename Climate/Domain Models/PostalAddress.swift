import Foundation

public struct PostalAddress: Hashable, Sendable {
    let countryCode: String
    let city: String
    let stateCode: String?
    
    public init(location: Location) {
        self.city = location.city
        self.countryCode = location.countryCode
        self.stateCode = nil
    }
    
    public init(geoLocation: GeoLocation) {
        self.city = geoLocation.address.city
        self.countryCode = geoLocation.address.countryCode
        self.stateCode = geoLocation.address.stateCode
    }
    
    internal init(
        countryCode: String,
        city: String,
        stateCode: String?
    ) {
        self.countryCode = countryCode
        self.city = city
        self.stateCode = stateCode
    }
    
    public static let preview: Self = {
        Self.init(countryCode: "SE", city: "Stockholm", stateCode: nil)
    }()
}

public struct PostalAddressRequest: Equatable {
    let stateCode: String?
    let countryCode: String
    let city: String
    
    func formattedString() -> String {
        switch self.stateCode == nil {
        case true:
            return "\(self.city),\(self.countryCode)"
        case false:
            return "\(self.city),\(self.stateCode),\(self.countryCode)"
        }
    }
    
    public init(
        address: PostalAddress
    ) {
        self.city = address.city
        self.countryCode = address.countryCode
        self.stateCode = address.stateCode
    }
}


public struct GeoLocation: Hashable, Sendable {
    let coordinates: LocationCoordinates2D
    let address: PostalAddress
    
    public init(location: Location) {
        let coordinates = LocationCoordinates2D(
            latitude: location.latitude,
            longitude: location.longitude
        )
        self.init(
            address: .init(
                countryCode: location.countryCode,
                city: location.city,
                stateCode: nil
            ),
            location: coordinates
        )
    }
    
    public init(
        address: PostalAddress,
        location: LocationCoordinates2D
    ) {
        self.coordinates = location
        self.address = address
    }
    
    public init(location: LocationCoordinates2D) {
        self.coordinates = location
        self.address = PostalAddress(countryCode: "", city: "Current Location", stateCode: nil)
    }
    
    static let empty: Self = {
        Self.init(
            address: .init(
                countryCode: "",
                city: "",
                stateCode: ""
            ),
            location: .init()
        )
    }()
}
