import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct Main {
    @Dependency(LocationClient.self) var locationClient
    @Dependency(WeatherClient.self) var weatherClient
    
    @ObservableState
    struct State: Equatable {
        var weather: WeatherAtLocation
        var location: GeoLocation
        var units: TemperatureUnits = .metric
        var forecast: Forecast? = nil
        var alert: AlertState<Alert>
    }
    
    enum Action: Equatable, ViewAction, Sendable {
        
        public enum View: Equatable {
            case onAppear
        }
        
        public enum Location: Equatable, Sendable {
            case requestAuthorization(Result<EquatableVoid, LocationError>)
            case getCurrentLocation(Result<LocationCoordinates2D, LocationError>)
        }
        
        public enum WeatherAction: Equatable, Sendable {
            case getWeatherForCurrentLocation(WeatherAtLocation)
            case getForecastForCurrentLocation(Forecast)
        }
        
        case weather(WeatherAction)
        case view(View)
        case location(Location)
    }
    
    var body: some ReducerOf<Self> {
        Reduce {
            state, action in
            
            switch action {
                
            case .view(.onAppear):
                guard !state.location.address.countryCode.isEmpty else {
                    return .run { send in
                        await send(.location(.requestAuthorization(try locationClient.requestAuthorization())))
                    }
                }
                
                return .run { [location = state.location] send in
                    await send(.weather(.getWeatherForCurrentLocation(
                        try await weatherClient.currentWeatherAt(
                            CurrentWeatherRequest(location: location, temperatureUnits: .metric)
                        )))
                    )
                }
                
            case .location(.requestAuthorization(.success)):
                return .run { send in
                    await send(.location(.getCurrentLocation(try locationClient.getCurrentLocation())))
                }
                
            case let .location(.requestAuthorization(.failure(error))):
                print(error)
                return .none
                
            case let .location(.getCurrentLocation(.success(location))):
                return .run {  send in
                    await send(
                        .weather(
                            .getWeatherForCurrentLocation(
                                try await weatherClient.currentWeatherAt(
                                    CurrentWeatherRequest(location: GeoLocation(location: location), temperatureUnits: .metric)
                                )))
                    )
                }
                
            case let .location(.getCurrentLocation(.failure(error))):
                // TODO: handle error
                print(error)
                return .none
                
            case let .weather(.getWeatherForCurrentLocation(weather)):
                state.weather = weather
                return .run { [location = state.location, units = state.units] send in
                    
                     let result = try await weatherClient.fiveDayForecast(
                            ForecastRequest(
                                latitude: location.coordinates.latitude,
                                longitude: location.coordinates.longitude,
                                units: units
                            )
                        )
                    await send(.weather(.getForecastForCurrentLocation(result)))
                }
            case let .weather(.getForecastForCurrentLocation(forecast)):
                state.forecast = forecast
                return .none
            }
        }
    }
}


