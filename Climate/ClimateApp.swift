import SwiftUI
import ComposableArchitecture
import CoreLocation

@main
struct ClimateApp: App {
    
    let store = Store(initialState: AppCoordinator.State(location: Shared(nil))) {
        AppCoordinator()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinator.View(store: store)
        }
    }
}
