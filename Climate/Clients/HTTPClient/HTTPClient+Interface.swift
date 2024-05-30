import Dependencies
import Foundation
import DependenciesMacros

@DependencyClient
public struct HTTPClient: Sendable, DependencyKey {
    
    public typealias MakeRequest = @Sendable (URLRequest) async throws -> Data
    
    public let makeRequest: MakeRequest
}

