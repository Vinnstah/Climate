import SwiftUI
import Foundation

struct CurrentWeatherView: View {
    let location: GeoLocation
    let weather: WeatherAtLocation
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
                    Image(weather.conditions.image)
                        .resizable()
                        .frame(width: geo.size.width/2.2, height: geo.size.width/2.2)
                }
                
                VStack {
                    Text("\(weather.temperature.temp.roundedNumberFormatted()) \(units.description)")
                        .font(.system(size: 55))
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.accentColor)
                    Text("\(weather.conditions.description.capitalized)")
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
    let weather: WeatherAtLocation
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
                    Text("\(weather.wind.roundedNumberFormatted()) km/h")
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
    let forecasts: Forecast?
    let unit: TemperatureUnits
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            Text("Forecasts")
            ScrollView(.horizontal) {
                HStack {
                    ForEach(forecasts?.list ?? [], id: \.self.dt) { forecast in
                        ZStack {
                            Rectangle()
                                .clipShape(.capsule)
                                .foregroundStyle(Color.primaryColor)
                            VStack {
                                ZStack {
                                    Circle()
                                        .frame(width: geo.size.width/5)
                                        .foregroundStyle(Color.primaryColor)
                                    Image(forecast.weather?.first!.icon ?? "01d")
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: geo.size.width/5)
                                }
                                Spacer()
                                Text(forecast.main?.temp?.roundedNumberFormatted() ?? "" + "\(unit.description)")
                                    .font(.system(size: 22))
                                    .fontWeight(.heavy)
                                    .foregroundStyle(Color.accentColor)
                                
//                                    .font(.system(size: 12))
//                                    .fontWeight(.bold)
//                                    .foregroundStyle(Color.accentColor)
                                
//                                    .font(.system(size: 8))
//                                    .fontWeight(.footnote)
//                                    .foregroundStyle(Color.accentColor)
                                
                            }
                            .padding(10)
                        }
                        .frame(width: geo.size.width/5)
                    }
                }
            }
            Spacer()
        }
        .padding(15)
    }
}
