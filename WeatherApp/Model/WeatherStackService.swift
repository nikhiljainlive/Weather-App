//
//  WeatherStackService.swift
//  WeatherApp
//
//  Created by Admin on 10/05/21.
//

import Foundation

private enum API {
    static let key = "YOUR_API_KEY"
}

final class WeatherStackService: WeatherService {
    var fallbackService: WeatherService?
    
    init(fallbackService: WeatherService? = nil) {
        self.fallbackService = fallbackService
    }
    
    func fetchWeatherData(for city: String, completionHandler: @escaping (String?, WebServiceError?) -> Void) {
        let endpoint = "http://api.weatherstack.com/current?access_key=\(API.key)&query=\(city)&units=f"
        
        guard let safeUrlString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let endpointUrl = URL(string: safeUrlString) else {
            completionHandler(nil, .invalidUrl(endpoint))
            return
        }
        
        URLSession.shared.dataTask(with: endpointUrl) { [weak self] (data, response, error) in
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
                    completionHandler(nil, .invalidPayload(endpointUrl))
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let weatherStackContainer = try decoder.decode(WeatherStackContainer.self, from: responseData)
                
                guard let weatherDescription = weatherStackContainer.current?.weather_descriptions?.first,
                      let temperature = weatherStackContainer.current?.temperature else {
                    if let fallbackService = self?.fallbackService {
                        fallbackService.fetchWeatherData(for: city, completionHandler: completionHandler)
                    } else {
                        completionHandler(nil, .invalidPayload(endpointUrl))
                    }
                    return
                }
                
                let weatherInfo = "\(weatherDescription) \(temperature) F"
                completionHandler(weatherInfo, nil)
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
