import ComposableArchitecture
import Foundation
import SwiftUI
import MapKit
extension Search {
    struct View: SwiftUI.View {
        @Bindable var store: StoreOf<Search>
        
        var body: some SwiftUI.View {
            VStack {
                List {
                    Section {
                        TextField(text: $store.city.sending(\.view.cityQueryChanged)) {
                            Text("London, Stockholm, ...")
                                .foregroundStyle(Color.accentColor)
                        }
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    } header: {
                        Text("Location")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.primaryColor)
                    
                    Section {
                        TextField(text: $store.countryCode.sending(\.view.countryCodeQueryChanged)) {
                            Text("Country Code...")
                                .foregroundStyle(Color.accentColor)
                        }
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                    } header: {
                        Text("Country Code")
                            .foregroundStyle(.white)
                    } footer: {
                        Text("ISO 3801, 2- or 3- character codes only")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.primaryColor)
                    
                    if store.state.location.address.countryCode == "US" {
                        Section {
                            TextField(text:  $store.stateCode.sending(\.view.stateQueryChanged)) {
                                Text("NY, MA, CA...")
                                    .foregroundStyle(Color.accentColor)
                            }
                            .autocapitalization(.allCharacters)
                            .disableAutocorrection(true)
                        }
                    header: {
                        Text("State Code")
                            .foregroundStyle(.white)
                    } footer: {
                        Text("2-letter State Code, applicable for US only.")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.primaryColor)
                    }
                    
                    HStack {
                        Spacer()
                        Button("Get Locations") {
                            store.send(.view(.getLocationsButtonTapped))
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.accentColor)
                        .disabled(store.state.invalidInput() || store.state.requestInFlight)
                    }
                    .listRowBackground(Color.backgroundColor)
                }
                .scrollContentBackground(.hidden)
                
                if !store.locations.isEmpty {
                    SearchResultView(locations: store.state.locations) { searchResult in
                        store.send(.view(.setLocationButtonTapped(searchResult)))
                    }
                }
            }
        }
    }
}
