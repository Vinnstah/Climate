import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct AppCoordinator {
    
    @ObservableState
    struct State: Equatable, Sendable {
        @Presents var destination: Destination.State?
        @Shared var location: GeoLocation
        @Shared var weather: WeatherAtLocation
    }
    
    @Reducer(state: .equatable, .sendable, action: .equatable, .sendable)
    enum Destination: Sendable {
        case search(Search)
        case main(Main)
    }
    
    enum Action: Equatable, ViewAction, Sendable {
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
                state.destination = .main(Main.State(weather: state.weather, location: state.location))
                return .none
                
            case .view(.mainTapped):
                state.destination = .main(Main.State(weather: state.weather, location: state.location))
                return .none
                
            case .view(.searchTapped):
                state.destination = .search(Search.State(location: state.$location))
                return .none
                
            case .destination(.presented(.search(.delegate(.setLocation)))):
                state.destination = .main(Main.State(weather: state.weather, location: state.location))
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}
