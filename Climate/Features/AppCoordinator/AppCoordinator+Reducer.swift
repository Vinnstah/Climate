import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct AppCoordinator {
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        @Shared(.inMemory("location")) var location: Location = .empty
        @Shared(.inMemory("weather")) var weather: Weather = .mock
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Destination {
        case search(Search)
        case main(Main)
    }
    
    enum Action: Equatable, ViewAction {
        @CasePathable
        public enum View: Equatable {
            case mainTapped
            case searchTapped
            case onAppear
        }
        
        case destination(PresentationAction<Destination.Action>)
        case view(View)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .view(.onAppear):
                state.destination = .main(Main.State(weather: state.$weather, location: state.$location))
                return .none
                
            case .view(.mainTapped):
                state.destination = .main(Main.State(weather: state.$weather, location: state.$location))
                return .none
                
            case .view(.searchTapped):
                state.destination = .search(Search.State(location: state.$location))
                return .none
                
            case .destination(.presented(.search(.delegate(.setLocation)))):
                state.destination = .main(Main.State(weather: state.$weather, location: state.$location))
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
