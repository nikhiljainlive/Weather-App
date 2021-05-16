//
//  WeatherStackData.swift
//  WeatherApp
//
//  Created by Admin on 10/05/21.
//

import Foundation

struct WeatherStackContainer : Codable {
    var current : WeatherStackCurrent?
}

struct WeatherStackCurrent : Codable {
    let temperature : Int?
    let weather_descriptions : [String]?
}

struct WeatherStackCondition : Codable {
    var text : String
    var icon : String
}
