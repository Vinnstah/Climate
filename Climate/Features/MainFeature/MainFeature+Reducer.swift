import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct Main {
    @Dependency(LocationClient.self) var locationClient
    @Dependency(WeatherClient.self) var weatherClient
    
    @ObservableState
    struct State: Equatable, Sendable {
        var weather: WeatherAtLocation
        var location: GeoLocation
        var units: TemperatureUnits = .metric
        var forecast: Forecast? = nil
        @Presents var alert: AlertState<Main.Action.AlertAction>? = nil
    }
    
    enum Action: Equatable, ViewAction, Sendable, BindableAction {
        
        @CasePathable
        public enum AlertAction: Equatable {
            case dismiss
            case retryAuthorization
            case retryLocation
        }
        
        public enum View: Equatable {
            case onAppear
            case unitButtonPressed(TemperatureUnits)
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
        case alert(PresentationAction<AlertAction>)
        case binding(BindingAction<Main.State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
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
                state.alert = AlertState {
                    TextState("Failed Authorization")
                } actions: {
                    ButtonState(action: .send(.retryAuthorization)) {
                        TextState("Try Again")
                    }
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } message: {
                    TextState(error.localizedDescription)
                }
                return .none
                
            case let .location(.getCurrentLocation(.success(location))):
                return .run {  send in
                    
                    let result = try await weatherClient.currentWeatherAt(
                        CurrentWeatherRequest(
                            location: GeoLocation(
                                location: location
                            ),
                            temperatureUnits: .metric
                        )
                    )
                    await send(.weather(.getWeatherForCurrentLocation(result)))
                }
                
            case let .location(.getCurrentLocation(.failure(error))):
                state.alert = AlertState {
                    TextState("Failed to get Location")
                } actions: {
                    ButtonState(action: .send(.retryLocation)) {
                        TextState("Try Again")
                    }
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                } message: {
                    TextState(error.localizedDescription)
                }
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
                
            case .alert(.presented(.retryAuthorization)):
                return .run { send in
                    await send(.location(.requestAuthorization(try locationClient.requestAuthorization())))
                }
                
            case .alert(.presented(.retryLocation)):
                return .run { send in
                    await send(.location(.getCurrentLocation(try locationClient.getCurrentLocation())))
                }
                
            case let .weather(.getForecastForCurrentLocation(forecast)):
                state.forecast = forecast
                return .none
                
            case let .view(.unitButtonPressed(unit)):
                state.units = unit
                return .run { [location = state.location, units = state.units]  send in
                    
                    let result = try await weatherClient.currentWeatherAt(
                        CurrentWeatherRequest(location: location, temperatureUnits: units)
                    )
                    
                    await send(.weather(.getWeatherForCurrentLocation(result)))
                }
                
            case .alert, .binding:
                return .none
            }
        }
    }
}


