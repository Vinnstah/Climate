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
            locationsfromPostalAddress: { address in
                try await apiClient.coordinatesByLocationName(PostalAddressRequest(address: address))
                    .map( { GeoLocation(location: $0) })
            },
            fiveDayForecast: { request in
                try await apiClient.fiveDayForecast(request)
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
