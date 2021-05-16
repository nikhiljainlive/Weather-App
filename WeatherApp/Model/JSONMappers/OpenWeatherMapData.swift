//
//  OpenWeatherMapData.swift
//  WeatherApp
//
//  Created by Admin on 10/05/21.
//

import Foundation

struct OpenWeatherMapContainer: Codable {
    var list : [OpenWeatherMapData]?
}

struct OpenWeatherMapData : Codable {
    var weather : [OpenWeatherMapWeather]
    var main : OpenWeatherMapMain
}

struct OpenWeatherMapWeather : Codable {
    var id : Int?
    var main : String?
    var description : String?
    var icon : String?
}

struct OpenWeatherMapMain : Codable {
    var temp : Float?
}
