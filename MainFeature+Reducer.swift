import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct Main {
    @Dependency(LocationClient.self) var locationClient
    
    @ObservableState
    struct State: Equatable {
        var currentLocation: CLLocationCoordinate2D? = nil
    }
    
    enum Action: Equatable, ViewAction {
        @CasePathable
        public enum View: Equatable {
            case onAppear
        }
        
        case view(View)
        case requestAuthorization(Result<EquatableVoid, LocationError>)
        case getCurrentLocation(Result<CLLocationCoordinate2D, LocationError>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
                
            case .view(.onAppear):
                return .run { send in
                    await send(.requestAuthorization(try locationClient.requestAuthorization()))
                }
                
            case .requestAuthorization(.success):
                print("Success")
                return .run { send in
                    await send(.getCurrentLocation(try locationClient.getCurrentLocation()))
                }
                
            case let .requestAuthorization(.failure(error)):
                print(error)
                return .none
                
            case let .getCurrentLocation(.success(location)):
                state.currentLocation = location
                return .none
                
            case let .getCurrentLocation(.failure(error)):
                // TODO: handle error
                print(error)
                return .none
            }
        }
    }
}


