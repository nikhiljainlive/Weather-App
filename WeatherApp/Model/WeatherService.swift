//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Admin on 10/05/21.
//

import Foundation

public enum WebServiceError : Error {
    case invalidUrl(String)
    case invalidPayload(URL)
    case forwarded(Error)
}

public protocol WeatherService {
    init(fallbackService : WeatherService?)
    
    var fallbackService : WeatherService? { get }
    
    func fetchWeatherData(for city : String,
                          completionHandler : @escaping (String?, WebServiceError?) -> Void)
}
