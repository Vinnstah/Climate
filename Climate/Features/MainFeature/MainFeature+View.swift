import Foundation
import SwiftUI
import ComposableArchitecture

extension Main {
    struct View: SwiftUI.View {
        @Bindable var store: StoreOf<Main>
        var body: some SwiftUI.View {
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    
                    if store.weather.postalAddress.city == "Preview" {
                        MockedDataDisclaimerBanner()
                    }
                    
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

public struct MockedDataDisclaimerBanner: View {
    public var body: some View {
        Text("Using **Mocked** data since no API_KEY present")
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(4)
            .background(Color.accentColor)
            .font(.system(size: 12))
    }
    
    public init() {}
}
