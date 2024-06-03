import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct Main {
    @Dependency(LocationClient.self) var locationClient
    @Dependency(ApiClient.self) var apiClient
    
    @ObservableState
    struct State: Equatable {
        @Shared var weather: Weather
        var location: CLLocationCoordinate2D?
        var units: TemperatureUnits = .metric
    }
    
    enum Action: Equatable, ViewAction {
        
        public enum View: Equatable {
            case onAppear
        }
        
        public enum Location: Equatable {
            case requestAuthorization(Result<EquatableVoid, LocationError>)
            case getCurrentLocation(Result<CLLocationCoordinate2D, LocationError>)
        }
        
        public enum WeatherAction: Equatable {
            case getWeatherForCurrentLocation(Weather)
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
                guard state.location != nil else {
                    return .run { send in
                        await send(.location(.requestAuthorization(try locationClient.requestAuthorization())))
                    }
                }
                
                return .run { [location = state.location!] send in
                    await send(.weather(.getWeatherForCurrentLocation(
                        try await apiClient.currentWeatherData(
                            location,
                            TemperatureUnits.metric
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
                state.location = location
                return .run { [location] send in
                    await send(
                        .weather(
                            .getWeatherForCurrentLocation(
                                try await apiClient.currentWeatherData(
                                    location,
                                    TemperatureUnits.metric
                                )))
                    )
                }
                
            case let .location(.getCurrentLocation(.failure(error))):
                // TODO: handle error
                print(error)
                return .none
                
            case let .weather(.getWeatherForCurrentLocation(weather)):
                state.weather = weather
                return .none
            }
        }
    }
}


