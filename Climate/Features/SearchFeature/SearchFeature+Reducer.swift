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
        
        func invalidInput() -> Bool {
            guard (!locationInputs.city.isEmpty && !locationInputs.countryCode.isEmpty) else {
                return true
            }
            
            guard locationInputs.countryCode.count < 3 else {
                return true
            }
            
            if locationInputs.countryCode == "US" {
                guard !stateCode.state.isEmpty && stateCode.state.count == 2 else {
                    return true
                }
            }
            return false
        }
        
        public init(location: CLLocationCoordinate2D?) {
            self.locationInputs = .init(city: "", countryCode: "")
            self.stateCode = .init(state: "")
            self.searchResult = []
            self.requestInFlight = false
            self.location = location
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<Search.State>)
        case cityQueryChanged(String)
        case countryCodeQueryChanged(String)
        case stateQueryChanged(String)
        case view(View)
        
        case delegate(DelegateAction)
        
        case locationQueryResults([SearchResult])
        
        enum View: Equatable {
            case getLocationsButtonTapped
            case setLocationButtonTapped(SearchResult)
        }
        
        enum DelegateAction: Equatable {
            case setLocation(CLLocationCoordinate2D)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {

                
            case let .cityQueryChanged(query):
                state.locationInputs.city = query
                return .none
                
            case let .countryCodeQueryChanged(query):
                state.locationInputs.countryCode = query
                return .none
            case let .stateQueryChanged(query):
                state.stateCode.state = query
                return .none
            case .view(.getLocationsButtonTapped):
                state.requestInFlight = true
                return .run { [locationInputs = state.locationInputs, stateCode = state.stateCode] send in
                    await send(.locationQueryResults(try await apiClient.coordinatesByLocation(locationInputs, stateCode)))
                }
                
            case let .locationQueryResults(result):
                state.requestInFlight = false
                state.searchResult = result
                return .none
                
            case let .view(.setLocationButtonTapped(location)):
                let location = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
                state.location = location
                return .run { [location = state.location ] send in
                    await send(.delegate(.setLocation(location!)))
                }
                
            case .binding, .delegate:
                return .none
            }
        }
    }
}

