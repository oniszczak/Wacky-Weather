//
//  ContentView.swift
//  Wacky Weather
//
//  Created by ALEKSANDER ONISZCZAK on 2023-01-09.
//

/*
import SwiftUI
import CoreLocation
import WeatherKit
import Charts

class LocationManager: NSObject, ObservableObject {
    
    @Published var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last, currentLocation == nil else { return }
        
        DispatchQueue.main.async {
            self.currentLocation = location
        }
    }
}

extension Date {
    func formatAsAbbreviatedDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }
    
    func formatAsAbbreviatedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: self)
    }
}

struct HourlyForcastView: View {
    
    let hourWeatherList: [HourWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("HOURLY FORECAST")
                .font(.caption)
                .opacity(0.5)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(hourWeatherList, id: \.date) { hourWeatherItem in
                        VStack(spacing: 20) {
                            Text(hourWeatherItem.date.formatAsAbbreviatedTime())
                            Image(systemName: "\(hourWeatherItem.symbolName).fill")
                                .foregroundColor(.yellow)
                            Text(hourWeatherItem.temperature.formatted())
                                .fontWeight(.medium)
                        }.padding()
                    }
                }
            }
        }.padding().background {
            Color.blue
        }.clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .foregroundColor(.white)
    }
    
}

struct TenDayForcastView: View {
    
    let dayWeatherList: [DayWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("10-DAY FORCAST")
                .font(.caption)
                .opacity(0.5)
            
            List(dayWeatherList, id: \.date) { dailyWeather in
                HStack {
                    Text(dailyWeather.date.formatAsAbbreviatedDay())
                        .frame(maxWidth: 50, alignment: .leading)
                    
                    Image(systemName: "\(dailyWeather.symbolName)")
                        .foregroundColor(.yellow)
                    
                    Text(dailyWeather.lowTemperature.formatted())
                        .frame(maxWidth: .infinity)
                    
                    Text(dailyWeather.highTemperature.formatted())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }.listRowBackground(Color.blue)
            }.listStyle(.plain)
        }
        .frame(height: 300).padding()
        .background(content: {
            Color.blue
        })
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
        .foregroundColor(.white)
        
        //if let attributionLink {
        //    Text (attributionLink)
        //}
        
    }
}

struct HourlyForecastChartView: View {
    
    let hourlyWeatherData: [HourWeather]
    
    var body: some View {
        Chart {
            ForEach(hourlyWeatherData.prefix(10), id: \.date) { hourlyWeather in
                LineMark(x: .value("Hour", hourlyWeather.date.formatAsAbbreviatedTime()), y: .value("Temperature", hourlyWeather.temperature.converted(to: .fahrenheit).value))
            }
        }
    }
}


struct ContentView: View {
    
    let weatherService = WeatherService.shared
    @StateObject private var locationManager = LocationManager()
    @State private var weather: Weather?
    
    @State var attributionLink: URL?
    @State var attributionLogo: URL?
    
    var hourlyWeatherData: [HourWeather] {
        if let weather {
            return Array(weather.hourlyForecast.filter { hourlyWeather in
                return hourlyWeather.date.timeIntervalSince(Date()) >= 0
            }.prefix(24))
        } else {
            return []
        }
    }
    
    var body: some View {
        VStack {
            if let weather {
                VStack {
                    Text("Toronto")
                        .font(.largeTitle)
                    Text("\(weather.currentWeather.temperature.formatted())")
                }
                
                HourlyForcastView(hourWeatherList: hourlyWeatherData)
              //  Spacer()
                
                HourlyForecastChartView(hourlyWeatherData: hourlyWeatherData)
                
                TenDayForcastView(dayWeatherList: weather.dailyForecast.forecast)
            }
        }
        .padding()
        .task(id: locationManager.currentLocation) {
            do {
                //if let location = locationManager.currentLocation {
                let location = CLLocation(latitude: 43.6588820, longitude: -79.4852880)
                
                
                //let attribution = try await WeatherService.shared.attribution
                //    attributionLink = attribution.legalPageURL
                    //attributionLogo = colorScheme == .light ? attribution.combinedMarkDarkURL : attribution.combinedMarkLightURL
                 //   attributionLogo = attribution.combinedMarkLightURL
                
                
                self.weather =  try await weatherService.weather(for: location)
               // }
            } catch {
                print(error)
            }
            
        }
        //Link("Apple.com", destination: attributionLink!)
        //Text (String(attributionLink))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

*/




import SwiftUI
import CoreLocation
import WeatherKit

//var weatherService = WeatherService ()
//var syracuse = CLLocation (latitude: 43, longitude: -76)
//var weather = try! await weatherService.weather(for: syracuse)
//var temperature = weather.currentWeather.temperature
//var uvIndex = weather.currentWeather.uvIndex

struct ContentView: View {
    
    static let location =
    CLLocation(
        latitude: .init(floatLiteral: 43.6588820),
        longitude: .init(floatLiteral: -79.4852880)
    )
    
    @State var weather: Weather?
    
    @State var weatherAttr: Weather?
    @State var attribution: WeatherAttribution?
    
    @State var attText: String?
    @State var attURL: URL?
    
    func getWeather() async {
        do {
            weather = try await Task
            {
                try await WeatherService.shared.weather(for: Self.location)
            }.value
        } catch {
            fatalError("\(error)")
        }
    }
    
    var body: some View {
        
        if let weather = weather {
            VStack{
                Spacer()
                Text("Toronto").font(.largeTitle).padding(.bottom, -20.0).foregroundColor(.blue)
                Text(weather.currentWeather.temperature.description)
                    .font(.system(size: 60))
                Text(weather.currentWeather.condition.description).font(.title).padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing], 1.0/*@END_MENU_TOKEN@*/)
                Image(systemName: weather.currentWeather.symbolName).padding(/*@START_MENU_TOKEN@*/.all, 4.0/*@END_MENU_TOKEN@*/).font(.title)
                Spacer()
                Link(attText ?? "Apple Weather", destination: attURL ?? URL(string: "https://apple.com/")!)
            }
            
            // Apple Weather Attribution
            .task {
                do {
                    let attribution = try await WeatherService.shared.attribution
                    //print (attribution.serviceName, attribution.legalPageURL)
                    //print (attribution)
                    attText = attribution.serviceName
                    attURL = attribution.legalPageURL
                    
                } catch {
                    print (error)
                }
            }
            
            } else {
                    ProgressView()
                    .task {
                        await getWeather ()
                    }
            }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

