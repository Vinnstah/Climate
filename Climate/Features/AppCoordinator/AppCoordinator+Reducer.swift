import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct AppCoordinator {
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State? 
        @Shared var location: CLLocationCoordinate2D?
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
                state.destination = .main(Main.State(weather: Shared(.mock)))
                return .none
                
            case .view(.mainTapped):
                state.destination = .main(Main.State(weather: Shared(.mock)))
                return .none
                
            case .view(.searchTapped):
                state.destination = .search(Search.State(location: state.location))
                return .none
                
            case let .destination(.presented(.search(.delegate(.setLocation(location))))):
                state.location = location
                state.destination = .main(Main.State(weather: Shared(.mock), location: state.location))
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
