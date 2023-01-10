//
//  ContentView.swift
//  Wacky Weather
//
//  Created by ALEKSANDER ONISZCZAK on 2023-01-09.
//

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
                Text("Toronto").font(.largeTitle).padding().foregroundColor(.blue)
                Text(weather.currentWeather.temperature.description)
                    .font(.system(size: 60))
                Text(weather.currentWeather.condition.description).font(.title)
                Image(systemName: weather.currentWeather.symbolName).font(.title)
                
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
