import SwiftUI
import Foundation

struct CurrentWeatherView: View {
    let location: Location
    let weather: Weather
    let units: TemperatureUnits
    let geo: GeometryProxy
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                location.address.city.isEmpty ? Text("Current Location") : Text(location.address.city + ", \(location.address.countryCode)")
                    .fontWeight(.bold)
            }
            HStack {
                ZStack {
                    Circle()
                        .frame(width: geo.size.width/2)
                        .foregroundStyle(Color.primaryColor)
                    Image(weather.currentWeather.first?.icon ?? "01d")
                        .resizable()
                        .frame(width: geo.size.width/2.2, height: geo.size.width/2.2)
                }
                
                VStack {
                    Text("\(weather.temperature.temp.roundedNumberFormatted()) \(units.description)")
                        .font(.system(size: 55))
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.accentColor)
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
                .foregroundStyle(Color.primaryColor)
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
                    .overlay(Color.backgroundColor)
                VStack {
                    Text("Feels like")
                        .fontWeight(.bold)
                        .font(.title3)
                    Text("\(weather.temperature.feelsLike.roundedNumberFormatted()) °C")
                }
                Divider()
                    .frame(width: 2, height: geo.size.height*0.1)
                    .overlay(Color.backgroundColor)
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
                    .foregroundStyle(Color.primaryColor)
                Rectangle()
                    .clipShape(.capsule)
                    .foregroundStyle(Color.primaryColor)
                Rectangle()
                    .clipShape(.capsule)
                    .foregroundStyle(Color.primaryColor)
            }
            Spacer()
        }
        .padding(15)
    }
}
