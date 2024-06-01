import ComposableArchitecture
import Foundation

@Reducer
struct AppCoordinator {
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        
        public init() {
            self.destination = .main(Main.State(weather: Shared(.mock)))
        }
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
        }
        
        case destination(PresentationAction<Destination.Action>)
        case view(View)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(_):
                return .none
           
            case .view(.mainTapped):
                state.destination = .main(Main.State(weather: Shared(.mock)))
                return.none
                
            case .view(.searchTapped):
                state.destination = .search(Search.State())
                return.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
