import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct Search {
    @Dependency(\.weatherClient) var weatherClient
    
    @ObservableState
    struct State: Equatable {
        var location: GeoLocation
        var locations: [GeoLocation] = []
        var requestInFlight: Bool = false
        
//        func invalidInput() -> Bool {
//            guard (
//                !location.city.isEmpty && !location.countryCode.isEmpty
//            ) else {
//                return true
//            }
//            
//            guard location.countryCode.count < 3 else {
//                return true
//            }
//            
//            if location.countryCode == "US" {
//                guard (
//                    !location.state .stateCode.isEmpty && location.stateCode.count == 2
//                ) else {
//                    return true
//                }
//            }
//            return false
//        }
        
//        public init(location: Shared<Location>) {
//            self.locations = []
//            self.requestInFlight = false
//            self._location = location
//        }
    }
    
    enum Action: Equatable, BindableAction, Sendable {
        case binding(BindingAction<Search.State>)
        case view(View)
        case delegate(DelegateAction)
        case locationQueryResults([GeoLocation])
        
        @CasePathable
        enum View: Equatable {
            case getLocationsButtonTapped
            case setLocationButtonTapped(GeoLocation)
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
                state.location.country = query
                return .none
                
            case let .view(.stateQueryChanged(query)):
//                state.location.stateCode = query
                return .none
                
            case .view(.getLocationsButtonTapped):
                state.requestInFlight = true
                return .run { [location = state.location] send in
                    await send(
                        .locationQueryResults(
                            try await weatherClient.locationsfromPostalAddress(PostalAddress(location: location), "")
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

