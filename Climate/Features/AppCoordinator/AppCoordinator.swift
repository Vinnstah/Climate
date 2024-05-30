import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct AppCoordinator {
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        
        public init() {
            self.destination = .main(Main.State())
        }
    }
    
    @Reducer(state: .equatable, action: .equatable)
    enum Destination {
        case search(Search)
        case main(Main)
    }
    
    enum Action: Equatable {
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(_):
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension AppCoordinator {
    struct View: SwiftUI.View {
        let store: StoreOf<AppCoordinator>
        
        public init(store: StoreOf<AppCoordinator>) {
            self.store = store
        }
        
        var body: some SwiftUI.View {
            VStack {
                switch store.state.destination {
                case .main:
                    Main.View()
                case .search:
                    Search.View()
                case .none:
                    EmptyView()
                }
            }
        }
    }
}
