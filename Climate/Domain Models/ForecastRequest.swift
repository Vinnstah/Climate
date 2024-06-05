import Foundation

public struct ForecastRequest: Equatable, Sendable {
    let latitude: Double
    let longitude: Double
    let units: TemperatureUnits
}
