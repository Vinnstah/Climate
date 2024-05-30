import Dependencies
import Foundation
import DependenciesMacros

@DependencyClient
public struct HTTPClient: Sendable {
    
    public typealias MakeRequest = @Sendable (URLRequest) async throws -> Data
    
    public let makeRequest: MakeRequest
}
