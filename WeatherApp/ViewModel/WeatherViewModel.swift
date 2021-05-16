//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Admin on 10/05/21.
//

import Foundation

class WeatherViewModel : ObservableObject {
    private let weatherService : WeatherService = OpenWeatherMapService(fallbackService: WeatherStackService())
    
    @Published var weatherInfo : String = ""
    
    func fetch(city : String) {
        weatherService.fetchWeatherData(for: city) { (info, error) in
            guard error == nil,
                  let weatherInfo = info
                  else {
                DispatchQueue.main.async {
                    self.weatherInfo = "Could not retrieve weather information for \(city)"
                }
                return
            }
            
            DispatchQueue.main.async {
                self.weatherInfo = weatherInfo
                print(weatherInfo)
            }
        }
    }
}
