import Dependencies
import Foundation

extension WeatherClient {
    
    public static let liveValue: WeatherClient = {
        @Dependency(ApiClient.self) var apiClient
        
        return .init(
            currentWeatherAt: { request in
                let weather = try await apiClient.currentWeatherAt(request)
                return WeatherAtLocation(weather: weather, location: request.location)
            },
            locationsfromPostalAddress: { address, stateCode in
                try await apiClient.coordinatesByLocationName(PostalAddressRequest(address: address, stateCode: stateCode))
                    .map( { GeoLocation(location: $0) })
            },
            fiveDayForecast: { location in
                try await apiClient.fiveDayForecast(location)
            })
    }()
}
extension WeatherClient: TestDependencyKey {
    public static let testValue = Self(
        currentWeatherAt: unimplemented("WeatherClient.currentWeatherAt"),
        locationsfromPostalAddress: unimplemented("WeatherClient.locationsfromPostalAddress"),
        fiveDayForecast: unimplemented("WeatherClient.fiveDayForecast"))
}

extension DependencyValues {
    public var weatherClient: WeatherClient {
        get { self[WeatherClient.self] }
        set { self[WeatherClient.self] = newValue }
    }
}
