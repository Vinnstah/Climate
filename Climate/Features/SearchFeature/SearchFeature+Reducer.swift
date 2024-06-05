import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct Search {
    @Dependency(\.apiClient) var apiClient
    
    @ObservableState
    struct State: Equatable {
        @Shared var location: Location
        var locations: [Location]
        var requestInFlight: Bool
        
        func invalidInput() -> Bool {
            guard (
                !location.address.city.isEmpty && !location.address.countryCode.isEmpty
            ) else {
                return true
            }
            
            guard location.address.countryCode.count < 3 else {
                return true
            }
            
            if location.address.countryCode == "US" {
                guard (
                    !location.address.stateCode.isEmpty && location.address.stateCode.count == 2
                ) else {
                    return true
                }
            }
            return false
        }
        
        public init(location: Shared<Location>) {
            self.locations = []
            self.requestInFlight = false
            self._location = location
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<Search.State>)
        case view(View)
        case delegate(DelegateAction)
        case locationQueryResults([Location])
        
        @CasePathable
        enum View: Equatable {
            case getLocationsButtonTapped
            case setLocationButtonTapped(Location)
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
                state.location.address.city = query
                return .none
                
            case let .view(.countryCodeQueryChanged(query)):
                state.location.address.countryCode = query
                return .none
                
            case let .view(.stateQueryChanged(query)):
                state.location.address.stateCode = query
                return .none
                
            case .view(.getLocationsButtonTapped):
                state.requestInFlight = true
                return .run { [postalAddress = state.location.address] send in
                    await send(
                        .locationQueryResults(
                            try await apiClient.coordinatesByLocationName(postalAddress)
                        )
                    )
                }
                
            case let .locationQueryResults(result):
                state.requestInFlight = false
                state.locations = result
                return .none
                
            case let .view(.setLocationButtonTapped(location)):
//                let location = CLLocationCoordinate2D(
//                    latitude: locations.coordinates.latitude,
//                    longitude: locations.coordinates.longitude
//                )
//                state.location.coordinates = location
//                state.location.address.city = locations.address.city
                state.location = location
                return .run { send in
                    await send(.delegate(.setLocation))
                }
                
            case .binding, .delegate:
                return .none
            }
        }
    }
}

