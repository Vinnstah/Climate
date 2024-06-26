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
            let baseURL: URL = .openWeather
            
            let url: URL = try {
                guard var urlComponents = URLComponents(
                    url: baseURL.appending(path: path),
                    resolvingAgainstBaseURL: true
                ) else {
                    throw ApiError.noComponents
                }
                
                urlComponents.queryItems = addQueryItems()
                
                guard let url = urlComponents.url else {
                    throw ApiError.failedToConstructURL
                }
                return url
            }()
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.httpMethod = "GET"
            
            return urlRequest
        }
        
        return .init(
            currentWeatherAt: {
                request in
                guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
                    throw ApiError.missingApiKey
                }
                var urlRequest = try buildRequest(
                    path: "data/2.5/weather",
                    addQueryItems: {
                        return [
                            URLQueryItem(name: "lat", value: request.location.coordinates.latitude.formatted()),
                            URLQueryItem(name: "lon", value: request.location.coordinates.longitude.formatted()),
                            URLQueryItem(name: "appid", value: apiKey),
                            URLQueryItem(name: "units", value: request.temperatureUnits?.rawValue),
                        ]
                    })
                
                let data = try await httpClient.makeRequest(urlRequest)
                return try decoder.decode(Weather.self, from: data)
                
            },
            coordinatesByLocationName: {
                request in
                guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
                    throw ApiError.missingApiKey
                }
                
                var urlRequest = try buildRequest(
                    path: "geo/1.0/direct",
                    addQueryItems: {
                        return [
                            URLQueryItem(
                                name: "q",
                                value:  request.formattedString()
                            ),
                            URLQueryItem(name: "limit", value: "5"),
                            URLQueryItem(name: "appid", value: apiKey),
                        ]
                    })
                let data = try await httpClient.makeRequest(urlRequest)
                return try decoder.decode([Location].self, from: data)
            },
            fiveDayForecast: { request in
                guard let apiKey = ProcessInfo.processInfo.environment["API_KEY"] else {
                    throw ApiError.missingApiKey
                }
                var urlRequest = try buildRequest(
                    path: "data/2.5/forecast",
                    addQueryItems: {
                        return [
                            URLQueryItem(
                                name: "lat",
                                value: request.latitude.description
                            ),
                            URLQueryItem(
                                name: "lon",
                                value: request.longitude.description
                            ),
                            URLQueryItem(name: "appid", value: apiKey),
                            URLQueryItem(name: "units", value: request.units.rawValue),
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

public enum ApiError: Error {
    case missingApiKey
    case noComponents
    case failedToConstructURL
}
