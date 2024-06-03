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
            guard (
                !locationInputs.city.isEmpty && !locationInputs.countryCode.isEmpty
            ) else {
                return true
            }
            
            guard locationInputs.countryCode.count < 3 else {
                return true
            }
            
            if locationInputs.countryCode == "US" {
                guard (
                !stateCode.state.isEmpty && stateCode.state.count == 2
                ) else {
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
        case view(View)
        case delegate(DelegateAction)
        case locationQueryResults([SearchResult])
        
        @CasePathable
        enum View: Equatable {
            case getLocationsButtonTapped
            case setLocationButtonTapped(SearchResult)
            case cityQueryChanged(String)
            case countryCodeQueryChanged(String)
            case stateQueryChanged(String)
        }
        
        enum DelegateAction: Equatable {
            case setLocation(CLLocationCoordinate2D)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case let .view(.cityQueryChanged(query)):
                state.locationInputs.city = query
                return .none
                
            case let .view(.countryCodeQueryChanged(query)):
                state.locationInputs.countryCode = query
                return .none
                
            case let .view(.stateQueryChanged(query)):
                state.stateCode.state = query
                return .none
                
            case .view(.getLocationsButtonTapped):
                state.requestInFlight = true
                return .run { [locationInputs = state.locationInputs, stateCode = state.stateCode] send in
                    await send(
                        .locationQueryResults(
                            try await apiClient.coordinatesByLocation(locationInputs, stateCode)
                        )
                    )
                }
                
            case let .locationQueryResults(result):
                state.requestInFlight = false
                state.searchResult = result
                return .none
                
            case let .view(.setLocationButtonTapped(searchResult)):
                let location = CLLocationCoordinate2D(
                    latitude: searchResult.lat,
                    longitude: searchResult.lon
                )
                state.location = location
                return .run { [location = state.location!] send in
                    await send(.delegate(.setLocation(location)))
                }
                
            case .binding, .delegate:
                return .none
            }
        }
    }
}

