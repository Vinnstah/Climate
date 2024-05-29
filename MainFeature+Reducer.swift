import ComposableArchitecture
import Foundation

@Reducer
struct MainFeature {
    
    @ObservableState
    struct State {}
    
    enum Action {}
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            }
        }
    }
}
