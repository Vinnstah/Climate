import ComposableArchitecture
import Foundation

@Reducer
struct Main {
    
    @ObservableState
    struct State: Equatable {}
    
    enum Action: Equatable {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
