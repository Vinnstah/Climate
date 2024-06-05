import SwiftUI
import Foundation
import CoreLocation

struct SearchResultView: View {
    let locations: [GeoLocation]
    let locationButtonTapped: (GeoLocation) -> ()
    
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
    let location: GeoLocation
    let setLocationAction: () -> ()
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                HStack {
                    Text(location.city)
                        .fontWeight(.heavy)
                    Text("(\(location.country))")
                    Spacer()
                }
                HStack {
                    Text("Latitude: \(location.coordinates.latitude)")
                        .font(.footnote)
                    Text("Longitude: \(location.coordinates.longitude)")
                        .font(.footnote)
                }
                .foregroundStyle(.white)
                Spacer()
                
            }
            .background(Color.backgroundColor)
            
            VStack {
                MapView(
                    coordinates: CLLocationCoordinate2D(
                        latitude: location.coordinates.latitude,
                        longitude: location.coordinates.longitude
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
