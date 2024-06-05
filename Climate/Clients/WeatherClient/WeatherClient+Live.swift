import Dependencies
import Foundation

extension WeatherClient {
    
    public static let liveValue: WeatherClient = {
        @Dependency(ApiClient.self) var apiClient
        
        return .init(
            currentWeatherAt: { request in
                do {
                    let weather = try await apiClient.currentWeatherAt(request)
                    return WeatherAtLocation(weather: weather, location: request.location)
                } catch ApiError.missingApiKey {
                    return WeatherAtLocation.preview
                }
            },
            locationsfromPostalAddress: { address in
                try await apiClient.coordinatesByLocationName(PostalAddressRequest(address: address))
                    .map( { GeoLocation(location: $0) })
            },
            fiveDayForecast: { request in
                do {
                    let forecast = try await apiClient.fiveDayForecast(request)
                    return forecast
                } catch ApiError.missingApiKey {
                    return Forecast.preview
                }
                
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
