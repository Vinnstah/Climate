import ComposableArchitecture
import Foundation
import CoreLocation

@Reducer
struct Search {
    @Dependency(\.weatherClient) var weatherClient
    
    @ObservableState
    struct State: Equatable {
        @Shared var location: GeoLocation
        var locations: [GeoLocation] = []
        var requestInFlight: Bool = false
        var countryCode: String = ""
        var stateCode: String = ""
        var city: String = ""
        
        
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
            case stateQueryChanged(String?)
        }
        
        enum DelegateAction: Equatable {
            case setLocation
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce {
            state,
            action in
            switch action {
                
            case let .view(.cityQueryChanged(query)):
                state.city = query
                return .none
                
            case let .view(.countryCodeQueryChanged(query)):
                state.countryCode = query
                return .none
                
            case let .view(.stateQueryChanged(query)):
                state.stateCode = query ?? ""
                return .none
                
            case .view(.getLocationsButtonTapped):
                state.requestInFlight = true
                let address = PostalAddress(
                    countryCode: state.countryCode,
                    city: state.city,
                    stateCode: state.stateCode == "" ? nil : state.stateCode
                )
                return .run {  send in
                    await send(
                        .locationQueryResults(
                            try await weatherClient.locationsfromPostalAddress(address)
                        )
                    )
                }
                
            case let .locationQueryResults(result):
                state.requestInFlight = false
                state.locations = result
                return .none
                
            case let .view(.setLocationButtonTapped(location)):
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

