import ComposableArchitecture
import Foundation
import SwiftUI

extension AppCoordinator {
    struct View: SwiftUI.View {
        let store: StoreOf<AppCoordinator>
        
        public init(store: StoreOf<AppCoordinator>) {
            self.store = store
        }
        
        var body: some SwiftUI.View {
            GeometryReader { geo in
                VStack {
                    switch store.state.destination {
                    case .main:
                        Main.View()
                            .transition(.move(edge: .leading))
                    case .search:
                        Search.View()
                            .transition(.move(edge: .trailing))
                    case .none:
                        EmptyView()
                    }
                }
                .tabView(home: { store.send(.view(.mainTapped)) }, search: { store.send(.view(.searchTapped)) }, geo: geo)
                .animation(.default, value: store.state.destination)
            }
        }
    }
}

