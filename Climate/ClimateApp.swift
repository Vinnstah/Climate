import SwiftUI
import ComposableArchitecture

@main
struct ClimateApp: App {
    
    static let store = Store(initialState: MainFeature.State()) {
        MainFeature()
    }
    var body: some Scene {
        WindowGroup {
            MainFeature.View()
        }
    }
}
