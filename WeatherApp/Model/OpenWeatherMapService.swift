//
//  OpenWeatherMapService.swift
//  WeatherApp
//
//  Created by Admin on 10/05/21.
//

import Foundation

private enum API {
    static let key = "YOUR_API_KEY"
}

final class OpenWeatherMapService : WeatherService {
    var fallbackService: WeatherService?
    
    init(fallbackService: WeatherService? = nil) {
        self.fallbackService = fallbackService
    }
    
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, WebServiceError?) -> Void) {
        let endpoint = "https://api.openweathermap.org/data/2.5/find?q=\(city)&units=imperial&appid=\(API.key)"
        
        guard let safeURLString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let endpointURL = URL(string: safeURLString) else {
            completionHandler(nil, .invalidUrl(endpoint))
            return
        }
        
        URLSession.shared.dataTask(with: endpointURL) {[weak self] data, response, error in
            guard error == nil else {
                if let fallbackService = self?.fallbackService {
                    fallbackService.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, .forwarded(error!))
                }
                return
            }
            
            guard let responseData = data else {
                if let fallbackService = self?.fallbackService {
                    fallbackService.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, .invalidPayload(endpointURL))
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let weatherContainer = try decoder.decode(OpenWeatherMapContainer.self, from: responseData)
                
                guard let weatherInfo = weatherContainer.list?.first,
                      let weather = weatherInfo.weather.first?.main,
                      let temperature = weatherInfo.main.temp else {
                    if let fallbackService = self?.fallbackService {
                        fallbackService.fetchWeatherData(for: city, completionHandler: completionHandler)
                    } else {
                        completionHandler(nil, .invalidPayload(endpointURL))
                    }
                    return
                }
                
                let weatherDescription = "\(weather) \(temperature) F"
                completionHandler(weatherDescription, nil)
            } catch let error {
                if let fallbackService = self?.fallbackService {
                    fallbackService.fetchWeatherData(for: city, completionHandler: completionHandler)
                } else {
                    completionHandler(nil, .forwarded(error))
                }
            }
        }.resume()
    }
}
