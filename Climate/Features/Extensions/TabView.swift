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
                    .frame(width: geo.size.width*0.8, height: 75, alignment: .center)
                    .foregroundStyle(Color("PrimaryColor"))
                    .opacity(0.8)
                HStack {
                    Button(
                        action: home, label: {
                            VStack {
                                Image(systemName: "cloud.sun.bolt")
                                    .foregroundStyle(Color("AccentColor"))
                                    .frame(width: geo.size.width/6, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Text("Home")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color("AccentColor"))
                            }
                        })
                            
                    
                    Button(
                        action: search, label: {
                            VStack {
                                Image(systemName: "location.magnifyingglass")
                                    .foregroundStyle(Color("AccentColor"))
                                    .frame(width: geo.size.width/6, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Text("Search")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color("AccentColor"))
                            }
                        })
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color("BackgroundColor").ignoresSafeArea())
    }
}
