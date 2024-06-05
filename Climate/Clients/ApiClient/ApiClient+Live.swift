import Dependencies
import Foundation

extension ApiClient {
    
    public static let liveValue: ApiClient = {
        @Dependency(HTTPClient.self) var httpClient
        let decoder = JSONDecoder()
        
        @Sendable func buildRequest(
            path: String,
            addQueryItems: @escaping () -> ([URLQueryItem])
        ) throws -> URLRequest {
            let baseURL = URL(string: "https://api.openweathermap.org/")!
            
            let url: URL = {
                guard var urlComponents = URLComponents(
                    url: baseURL.appending(path: path),
                    resolvingAgainstBaseURL: true
                ) else {
                    fatalError("no components")
                }
                
                urlComponents.queryItems = addQueryItems()
                
                guard let url = urlComponents.url else {
                    fatalError("Failed to construct URL")
                }
                return url
            }()
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.httpMethod = "GET"
            
            return urlRequest
        }
        
        return .init(
            currentWeatherAt: {
                location, unit in
                guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
                    fatalError("Did you forget to export API_KEY environment variable?")
                }
                var urlRequest = try buildRequest(
                    path: "data/2.5/weather",
                    addQueryItems: {
                        return [
                            URLQueryItem(name: "lat", value: location.latitude.formatted()),
                            URLQueryItem(name: "lon", value: location.longitude.formatted()),
                            URLQueryItem(name: "appid", value: apiKey),
                            URLQueryItem(name: "units", value: unit?.rawValue),
                        ]
                    })
                
                let data = try await httpClient.makeRequest(urlRequest)
                return try decoder.decode(Weather.self, from: data)
                
            },
            coordinatesByLocationName: {
                location in
                guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
                    fatalError("Did you forget to export API_KEY environment variable?")
                }
                
                var urlRequest = try buildRequest(
                    path: "geo/1.0/direct",
                    addQueryItems: {
                        return [
                            URLQueryItem(
                                name: "q",
                                value: location.formattedString()
                            ),
                            URLQueryItem(name: "limit", value: "5"),
                            URLQueryItem(name: "appid", value: apiKey),
                        ]
                    })
                let data = try await httpClient.makeRequest(urlRequest)
                return try decoder.decode([Location].self, from: data)
            },
            fiveDayForecast: { location in
                guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
                    fatalError("Did you forget to export API_KEY environment variable?")
                }
                var urlRequest = try buildRequest(
                    path: "data/2.5/forecast",
                    addQueryItems: {
                        return [
                            URLQueryItem(
                                name: "lat",
                                value: location.coordinates?.latitude.description
                            ),
                            URLQueryItem(
                                name: "lon",
                                value: location.coordinates?.longitude.description
                            ),
                            URLQueryItem(name: "appid", value: apiKey),
                        ]
                    })
                
                let data = try await httpClient.makeRequest(urlRequest)
                return try decoder.decode(Forecast.self, from: data)
                
            })
    }()
}

extension ApiClient: TestDependencyKey {
    public static let testValue = Self(
        currentWeatherAt: unimplemented("ApiClient.currentWeatherData"),
        coordinatesByLocationName: unimplemented("ApiClient.coordinatesByLocation"),
        fiveDayForecast: unimplemented("ApiClient.fiveDayForecast"))
}

extension DependencyValues {
    public var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}
