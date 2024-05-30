import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct Search {
    
    @ObservableState
    struct State: Equatable {}
    
    enum Action: Equatable {}
}

extension Search {
    struct View: SwiftUI.View {
        let store: StoreOf<Search>
        var body: some SwiftUI.View {
            Text("Search ")
        }
    }
}
