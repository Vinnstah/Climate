import SwiftUI
import Foundation
import CoreLocation

struct SearchResultView: View {
    let searchResult: [SearchResult]
    let locationButtonTapped: (SearchResult) -> ()
    
    var body: some View {
        Divider()
        List {
            ForEach(searchResult, id: \.self) { searchResult in
                SearchResultItem(location: searchResult) {
                    locationButtonTapped(searchResult)
                }
                .listRowBackground(Color.backgroundColor)
            }
        }
        .listRowBackground(Color.primaryColor)
        .scrollContentBackground(.hidden)
    }
}

struct SearchResultItem: View {
    let location: SearchResult
    let setLocationAction: () -> ()
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                HStack {
                    Text(location.name)
                        .fontWeight(.heavy)
                    Text("(\(location.country))")
                    Spacer()
                }
                HStack {
                    Text("Latitude: \(location.lat)")
                        .font(.footnote)
                    Text("Longitude: \(location.lon)")
                        .font(.footnote)
                }
                .foregroundStyle(.white)
                Spacer()
                
            }
            .background(Color.backgroundColor)
            
            VStack {
                MapView(coordinates: CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon))
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
