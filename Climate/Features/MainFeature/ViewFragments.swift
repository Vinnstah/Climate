import SwiftUI
import Foundation

struct CurrentWeatherView: View {
    let weather: Weather
    let units: TemperatureUnits
    let geo: GeometryProxy
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Text("City Name")
                    .fontWeight(.bold)
            }
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
                        .fontWeight(.heavy)
                        .foregroundStyle(Color("AccentColor"))
                    Text("\(weather.currentWeather.first?.description.capitalized ?? "")")
                        .font(.title3)
                }
            }
            HStack {
                DetailView(weather: weather, geo: geo)
            }
        }
        .padding(15)
    }
}

struct DetailView: View {
    let weather: Weather
    let geo: GeometryProxy
    
    var body: some View {
        ZStack {
                Capsule()
                    .foregroundStyle(Color("PrimaryColor"))
                    .frame(width: geo.size.width*0.9, height: geo.size.height*0.15)
                HStack {
                    VStack {
                        Text("Wind")
                            .fontWeight(.bold)
                            .font(.title3)
                        Text("\(weather.wind.speed.roundedNumberFormatted()) km/h")
                    }
                    Divider()
                        .frame(width: 2, height: geo.size.height*0.1)
                        .overlay(Color("BackgroundColor"))
                    VStack {
                        Text("Feels like")
                            .fontWeight(.bold)
                            .font(.title3)
                        Text("\(weather.temperature.feelsLike.roundedNumberFormatted())")
                    }
                    Divider()
                        .frame(width: 2, height: geo.size.height*0.1)
                        .overlay(Color("BackgroundColor"))
                    VStack {
                        Text("Humidity")
                            .fontWeight(.bold)
                            .font(.title3)
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
        VStack {
            Text("Forecasts")
            HStack {
                Rectangle()
                    .clipShape(.capsule)
                    .foregroundStyle(Color("PrimaryColor"))
                Rectangle()
                    .clipShape(.capsule)
                    .foregroundStyle(Color("PrimaryColor"))
                Rectangle()
                    .clipShape(.capsule)
                    .foregroundStyle(Color("PrimaryColor"))
            }
            Spacer()
        }
        .padding(15)
    }
}
