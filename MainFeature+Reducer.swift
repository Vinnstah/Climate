import ComposableArchitecture
import Foundation

@Reducer
struct Main {
    @Dependency(LocationClient.self) var locationClient
    
    @ObservableState
    struct State: Equatable {}
    
    enum Action: Equatable, ViewAction {
        @CasePathable
        public enum View: Equatable {
            case onAppear
        }
        
        case view(View)
        case requestAuthorization(Result<EquatableVoid, LocationError>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { send in
                        let result = try locationClient.requestAuthorization()
                        
                    await send(.requestAuthorization(result))
                }
            case .requestAuthorization(.success):
                print("Success")
                return .run { send in
                    print(try locationClient.getCurrentLocation())
                }
                
            case let .requestAuthorization(.failure(error)):
                print(error)
                return .none
            }
        }
    }
}


