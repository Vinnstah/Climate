import SwiftUI
import ComposableArchitecture

@main
struct ClimateApp: App {
    
    let store = Store(initialState: AppCoordinator.State()) {
        AppCoordinator()
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinator.View(store: store)
        }
    }
}
