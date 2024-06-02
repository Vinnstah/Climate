import ComposableArchitecture
import Foundation
import SwiftUI

extension Search {
    struct View: SwiftUI.View {
        @Bindable var store: StoreOf<Search>
        
        var body: some SwiftUI.View {
            VStack {
                List {
                    Section {
                        TextField(text: $store.locationInputs.city.sending(\.cityQueryChanged)) {
                            Text("London, Stockholm, ...")
                                .foregroundStyle(Color("AccentColor"))
                        }
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    } header: {
                        Text("Location")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color("PrimaryColor"))
                    
                    Section {
                        TextField(text: $store.locationInputs.countryCode.sending(\.countryCodeQueryChanged)) {
                            Text("Country Code...")
                                .foregroundStyle(Color("AccentColor"))
                        }
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                    } header: {
                        Text("Country Code")
                            .foregroundStyle(.white)
                        //                            .foregroundStyle(Color("AccentColor"))
                    } footer: {
                        Text("ISO 3801, 2- or 3- character codes only")
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color("PrimaryColor"))
                    
                    if store.state.locationInputs.countryCode == "US" {
                        Section {
                            TextField(text: $store.stateCode.state.sending(\.stateQueryChanged)) {
                                Text("NY, MA, CA...")
                                    .foregroundStyle(Color("AccentColor"))
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
                    .listRowBackground(Color("PrimaryColor"))
                    }
                    
                    HStack {
                        Spacer()
                        Button("Get Locations") {
                            store.send(.view(.getLocationsButtonTapped))
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color("AccentColor"))
                        .disabled(store.state.invalidInput() || store.state.requestInFlight)
                    }
                    .listRowBackground(Color("BackgroundColor"))
                }
                .scrollContentBackground(.hidden)
                
                // TODO: BUILD A MODAL INSTEAD?
                if store.searchResult != [] {
                    Divider()
                    List {
                        ForEach(store.searchResult, id: \.self) { location in
                            Section {
                                Text(location.name)
                                Text("Latitude: \(location.lat)")
                                Text("Longitude: \(location.lon)")
                            }
                            .listRowBackground(Color("BackgroundColor"))
                        }
                    }
                    .listRowBackground(Color("PrimaryColor"))
                    .scrollContentBackground(.hidden)
                }
            }
        }
    }
}
