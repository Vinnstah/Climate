import SwiftUI
import Foundation
import ComposableArchitecture

extension View {
    func tabView(
        home: @escaping () -> Void,
        search: @escaping () -> Void,
        geo: GeometryProxy
    ) -> some View {
        VStack {
            self
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .frame(width: geo.size.width*0.8, height: 100, alignment: .center)
                    .foregroundStyle(Color("PrimaryColor"))
                    .opacity(0.8)
                HStack {
                    Button(
                        action: home, label: {
                            Image(systemName: "cloud.sun.bolt")
                                .foregroundStyle(Color("AccentColor"))
                                .frame(width: geo.size.width/6, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        })
                    
                    Button(
                        action: search, label: {
                            Image(systemName: "location.magnifyingglass")
                                .foregroundStyle(Color("AccentColor"))
                                .frame(width: geo.size.width/6, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        })
                }
            }
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
    }
}
