import SwiftUI
import Foundation

struct CurrentWeatherView: View {
    let location: GeoLocation
    let weather: WeatherAtLocation
    @State var units: TemperatureUnits
    let geo: GeometryProxy
    let unitChanged: (TemperatureUnits) -> ()
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Picker("", selection: $units) {
                    ForEach(TemperatureUnits.allCases, id: \.self) { unit in
                        Text(unit.description)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: geo.size.width/4)
                
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
        .onChange(of: units) { oldValue, newValue in
            unitChanged(newValue)
        }
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
            Text("Forecast")
                .font(.system(size: 24))
                .fontWeight(.heavy)
                .foregroundStyle(Color.accentColor)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(forecasts?.list ?? [], id: \.self.dt) { forecast in
                        ZStack {
                            Rectangle()
                                .clipShape(.capsule)
                                .foregroundStyle(Color.primaryColor)
                            VStack {
                                TemperatureImageView(
                                    forecast: forecast,
                                    geo: geo,
                                    unit: unit
                                )
                                Spacer()
                                
                                Text(forecast.date())
                                    .font(.system(size: 10))
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.white)
                                
                                Text(forecast.time())
                                    .font(.system(size: 10))
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.white)
                            }
                            .padding(.vertical, 5)
                        }
                        .frame(width: geo.size.width/5)
                    }
                    .padding(2)
                }
            }
            Spacer()
        }
        .frame(height: geo.size.height/3)
        .padding(15)
    }
}

struct TemperatureImageView: View {
    let forecast: ForecastWeather
    let geo: GeometryProxy
    let unit: TemperatureUnits
    
    var body: some View {
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
            HStack {
                Text(forecast.main?.temp?.roundedNumberFormatted() ?? "")
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.accentColor)
                Text("\(unit.description)")
                    .font(.system(size: 20))
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}
