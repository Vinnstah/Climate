import SwiftUI
import Foundation

struct CurrentWeatherView: View {
    let weather: Weather
    let units: TemperatureUnits
    let geo: GeometryProxy
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: geo.size.width/2)
                        .foregroundStyle(Color("PrimaryColor"))
                    Image(weather.currentWeather.first?.icon ?? "01d")
                        .resizable()
                        .frame(width: geo.size.width/2.2, height: geo.size.width/2.2)
                }
                
                VStack {
                    Text("\(weather.temperature.temp.roundedNumberFormatted()) \(units.description)")
                        .font(.system(size: 55))
                        .foregroundStyle(Color("AccentColor"))
                    Text("\(weather.currentWeather.first?.description.capitalized ?? "")")
                }
            }
            DetailView(weather: weather, geo: geo)
        }
    }
}

struct DetailView: View {
    let weather: Weather
    let geo: GeometryProxy
    
    var body: some View {
        ZStack {
                Capsule()
                    .foregroundStyle(Color("PrimaryColor"))
                    .frame(width: geo.size.width*0.8, height: geo.size.height*0.2)
//                    .padding(.horizontal, 10)
                HStack {
                    VStack {
                        Text("Wind")
                        Text("\(weather.wind.speed.roundedNumberFormatted()) km/h")
                    }
                    VStack {
                        Text("Feels like")
                        Text("\(weather.temperature.feelsLike.roundedNumberFormatted())")
                    }
                    VStack {
                        Text("Humidity")
                        Text("\(weather.temperature.humidity)%")
                    }
                }
                .foregroundStyle(.white)
            }
    }
}

struct ForecastView: View {
    let forecast: [String] = []
    
    var body: some View {
        HStack {
            HStack {
                Rectangle()
                    .clipShape(.capsule)
//                                .frame(width: geo.size.width*0.3, height: geo.size.height/5)
                Rectangle()
                    .clipShape(.capsule)
//                                .frame(width: geo.size.width*0.3, height: geo.size.height/5)
                Rectangle()
                    .clipShape(.capsule)
//                                .frame(width: geo.size.width*0.3, height: geo.size.height/5)
            }
        }
        
    }
}

extension Double {
    func roundedNumberFormatted() -> String {
        return self.formatted(.number.rounded(increment: 1))
    }
}
