import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct Search {
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    struct State: Equatable {
        @Shared var location: Location
        var searchResult: [SearchResult]
        var requestInFlight: Bool
        
        func invalidInput() -> Bool {
            guard (
                !location.city.isEmpty && !location.countryCode.isEmpty
            ) else {
                return true
            }
            
            guard location.countryCode.count < 3 else {
                return true
            }
            
            if location.countryCode == "US" {
                guard (
                    !location.stateCode.isEmpty && location.stateCode.count == 2
                ) else {
                    return true
                }
            }
            return false
        }
        
        public init(location: Shared<Location>) {
            self.searchResult = []
            self.requestInFlight = false
            self._location = location
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
            case setLocation
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                
            case let .view(.cityQueryChanged(query)):
                state.location.city = query
                return .none
                
            case let .view(.countryCodeQueryChanged(query)):
                state.location.countryCode = query
                return .none
                
            case let .view(.stateQueryChanged(query)):
                state.location.stateCode = query
                return .none
                
            case .view(.getLocationsButtonTapped):
                state.requestInFlight = true
                return .run { [location = state.location] send in
                    await send(
                        .locationQueryResults(
                            try await apiClient.coordinatesByLocation(location)
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
                state.location.location = location
                state.location.city = searchResult.name
                return .run { send in
                    await send(.delegate(.setLocation))
                }
                
            case .binding, .delegate:
                return .none
            }
        }
    }
}

