import Foundation
import SwiftUI
import ComposableArchitecture

extension Main {
    struct View: SwiftUI.View {
        let store: StoreOf<Main>
        var body: some SwiftUI.View {
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    CurrentWeatherView(
                        weather: store.state.weather,
                        units: store.units,
                        geo: geo
                    )
                    
                    ForecastView()
                }
            }
            .background(Color("BackgroundColor").ignoresSafeArea())
            .onAppear {
                store.send(.view(.onAppear))
            }
            
        }
    }
}
