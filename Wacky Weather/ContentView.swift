//
//  scratchpad.swift
//  Drunk Weather (AKA Wacky Weather)
//
//  Created by ALEKSANDER ONISZCZAK on 2023-01-10.
//

import SwiftUI
import CoreLocation
import WeatherKit
import AVFoundation

struct ContentView: View {
    
    let synthesizer = AVSpeechSynthesizer()
    
    
//***********************************************************
    //static let location =
    //static let location =
    //CLLocation(
    //    latitude: .init(floatLiteral: 43.6588820),
    //    longitude: .init(floatLiteral: 79.4852880)
    //)
    
    @State var weather: Weather?
    @State var attribution: WeatherAttribution?
    //@State var theTemperature: String?
    @State var attText: String?
    @State var attURL: URL?
    
    @StateObject var locationDataManager = LocationDataManager()
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    func getWeather() async {
        
        if let theLatitude = locationDataManager.locationManager.location?.coordinate.latitude.description {
            if let theLongitude = locationDataManager.locationManager.location?.coordinate.longitude.description {
                
                let realLocation =
                CLLocation(
                    latitude: .init(floatLiteral: CLLocationDegrees(theLatitude)!),
                    longitude: .init(floatLiteral: CLLocationDegrees(theLongitude)!)
                )
                
                do {
                    weather = try await Task
                    {
                        //try await WeatherService.shared.weather(for: Self.location)
                        try await WeatherService.shared.weather(for: realLocation)
                    }.value
                } catch {
                    fatalError("\(error)")
                }
                
            }
        }
        
    }
    
    func speakWeather(_ Temperature: String, _ Description: String) -> Void {
        print ("speakWeather")
        
        //let fullSentence = "It's " + Description + "outside. And the temperature is exactly " + Temperature + ". Yaaaaaaaaaaaay!"
        let fullSentence = "The temperature is exactly " + Temperature + ". Yaaaaaaaaaaaay!"
        
        let utterance = AVSpeechUtterance(string: fullSentence)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.1

        //let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        return
        
    }
    
    var body: some View {
        
        if let weather = weather {
            let theTemperature = weather.currentWeather.temperature.description
            let theDescription = weather.currentWeather.condition.description
            
            
            //let theLatitude = locationDataManager.locationManager.location?.coordinate.latitude.description
            //let theLongitude = locationDataManager.locationManager.location?.coordinate.longitude.description
            
            VStack {
                        switch locationDataManager.locationManager.authorizationStatus {
                        case .authorizedWhenInUse:  // Location services are available.
                            // Insert code here of what should happen when Location services are authorized
                            
                            //let theLatitude = locationDataManager.locationManager.location?.coordinate.latitude.description
                            //let theLongitude = locationDataManager.locationManager.location?.coordinate.longitude.description
                            
                            Text("Your current location is:")
                            Text("Latitude: \(locationDataManager.locationManager.location?.coordinate.latitude.description ?? "Error loading")")
                            Text("Longitude: \(locationDataManager.locationManager.location?.coordinate.longitude.description ?? "Error loading")")
                            
                        case .restricted, .denied:  // Location services currently unavailable.
                            // Insert code here of what should happen when Location services are NOT authorized
                            Text("Current location data was restricted or denied.")
                        case .notDetermined:        // Authorization not determined yet.
                            Text("Finding your location...")
                            ProgressView()
                        default:
                            ProgressView()
                        }
                    }
            
            
            
            
            VStack{
                Spacer()
                Text("Toronto").font(.largeTitle).padding(.bottom, -20.0).foregroundColor(.blue)
                
                Text(theTemperature)
                    .font(.system(size: 60))
                    .onTapGesture {
                        print("Tappy")
                        speakWeather (theTemperature, theDescription)
                    }
                
                Text(theDescription).font(.title).padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing], 1.0/*@END_MENU_TOKEN@*/)
                
                Image(systemName: weather.currentWeather.symbolName).padding(/*@START_MENU_TOKEN@*/.all, 4.0/*@END_MENU_TOKEN@*/).font(.title)
                
                //Tests if screen refreshed
                Text("Your lucky numbers are \(Int.random(in: 1..<49)) \(Int.random(in: 1..<49)) \(Int.random(in: 1..<49)) \(Int.random(in: 1..<49)) \(Int.random(in: 1..<49)) \(Int.random(in: 1..<49))")
                
                //Hack to refresh screen
                Toggle("Dark Mode", isOn: $isDarkMode).hidden()
                Button("Refresh") {
                    if isDarkMode == true {
                        isDarkMode = false
                    } else {
                        isDarkMode = true
                    }
                }
                
                
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

