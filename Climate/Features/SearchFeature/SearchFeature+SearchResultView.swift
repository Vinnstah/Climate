import SwiftUI
import Foundation
import CoreLocation

struct SearchResultView: View {
    let locations: [Location]
    let locationButtonTapped: (Location) -> ()
    
    var body: some View {
        Divider()
        List {
            ForEach(locations, id: \.self) { location in
                SearchResultItem(location: location) {
                    locationButtonTapped(location)
                }
                .listRowBackground(Color.backgroundColor)
            }
        }
        .listRowBackground(Color.primaryColor)
        .scrollContentBackground(.hidden)
    }
}

struct SearchResultItem: View {
    let location: Location
    let setLocationAction: () -> ()
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                HStack {
                    Text(location.address.city)
                        .fontWeight(.heavy)
                    Text("(\(location.address.countryCode))")
                    Spacer()
                }
                HStack {
                    Text("Latitude: \(location.coordinates?.latitude ?? 0)")
                        .font(.footnote)
                    Text("Longitude: \(location.coordinates?.longitude ?? 0)")
                        .font(.footnote)
                }
                .foregroundStyle(.white)
                Spacer()
                
            }
            .background(Color.backgroundColor)
            
            VStack {
                MapView(
                    coordinates: CLLocationCoordinate2D(
                        latitude: location.coordinates?.latitude ?? 0,
                        longitude: location.coordinates?.longitude ?? 0
                    )
                )
                .frame(width: 100, height: 100, alignment: .trailing)
                
                Button("Set Location") {
                    setLocationAction()
                    print("Pressed")
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.accentColor)
            }
        }
    }
}
