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
        var body: some SwiftUI.View {
            Text("Search ")
        }
    }
}
