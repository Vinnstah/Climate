import SwiftUI
import Foundation
import MapKit

struct MapView: View {
    
    var position: MapCameraPosition
    var coordinates: CLLocationCoordinate2D
    
    public init(
        coordinates: CLLocationCoordinate2D
    ) {
        self.coordinates = coordinates
        self.position = .region(
            .init(
                center: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            )
        )
    }
    
    var body: some View {
        Map(initialPosition: position) {
            Marker(coordinate: coordinates) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
        }
    }
}
