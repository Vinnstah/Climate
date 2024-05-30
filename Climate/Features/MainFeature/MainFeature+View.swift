import Foundation
import SwiftUI
import ComposableArchitecture

extension Main {
    struct View: SwiftUI.View {
        let store: StoreOf<Main>
        var body: some SwiftUI.View {
            GeometryReader { geo in
                HStack {
                    Spacer()
                    VStack {
                        Text("Current Weather")
                        Rectangle()
                            .clipShape(.capsule)
                            .frame(width: geo.size.width*0.9, height: geo.size.height/2, alignment: .center)
                        
                        Text("Forecast")
                        HStack {
                            Rectangle()
                                .clipShape(.capsule)
                                .frame(width: geo.size.width*0.3, height: geo.size.height/5)
                            Rectangle()
                                .clipShape(.capsule)
                                .frame(width: geo.size.width*0.3, height: geo.size.height/5)
                            Rectangle()
                                .clipShape(.capsule)
                                .frame(width: geo.size.width*0.3, height: geo.size.height/5)
                        }
                    }
                    Spacer()
                }
            }
            .onAppear {
                store.send(.view(.onAppear))
            }
        }
    }
}
