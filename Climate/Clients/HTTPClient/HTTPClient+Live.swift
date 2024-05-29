import Dependencies
import Foundation

extension HTTPClient {
    public static let liveValue: HTTPClient = {
        let urlSession = URLSession.shared
        
        return .init(
            makeRequest: { request in
                
                let (data, urlResponse) = try await urlSession.data(for: request)
                
                guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                    throw URLError(.unknown)
                }
                
                guard httpUrlResponse.statusCode == HTTPStatusCodes.Ok.rawValue else {
                    throw HTTPStatusCodes(rawValue: httpUrlResponse.statusCode) ?? HTTPStatusCodes.Unknown
                }
                
                return data
            })
    }()
}
