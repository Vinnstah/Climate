import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct Search {
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    struct State: Equatable {
        var location: CLLocationCoordinate2D?
        var locationInputs: Location
        var stateCode: StateLocation
        var searchResult: [SearchResult]
        var requestInFlight: Bool
        
        public init(location: CLLocationCoordinate2D?) {
            self.locationInputs = .init(city: "", countryCode: "")
            self.stateCode = .init(state: "")
            self.searchResult = []
            self.requestInFlight = false
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<Search.State>)
            case cityQueryChanged(String)
            case countryCodeQueryChanged(String)
            case stateQueryChanged(String)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .cityQueryChanged(query):
                state.locationInputs.city = query
                return .none
                
            case let .countryCodeQueryChanged(query):
                state.locationInputs.countryCode = query
                return .none
            case let .stateQueryChanged(query):
                state.stateCode.state = query
                return .none
            }
        }
    }
}

