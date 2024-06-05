import Foundation
import SwiftUI
import ComposableArchitecture

extension Main {
    struct View: SwiftUI.View {
        @Bindable var store: StoreOf<Main>
        var body: some SwiftUI.View {
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    
                    CurrentWeatherView(
                        location: store.location,
                        weather: store.state.weather,
                        units: store.units,
                        geo: geo
                    )
                    
                    ForecastView(
                        forecasts: store.state.forecast, 
                        unit: store.units,
                        geo: geo
                    )
                }
            }
            .alert($store.scope(state: \.alert, action: \.alert))
            .background(Color.backgroundColor.ignoresSafeArea())
            .onAppear {
                store.send(.view(.onAppear))
            }
        }
    }
}
