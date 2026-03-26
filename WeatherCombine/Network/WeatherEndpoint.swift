//
//  WeatherEndpoint.swift
//  WeatherCombine
//
//  Created by John Jones on 3/13/26.
//

import Foundation

enum WeatherEndpoint {
    case weather(lat: Double, lon: Double)
    case geocode(city: String)
}

extension WeatherEndpoint {
    
    var baseURL: String {
        switch self {
        case .weather(_,_):
            "https://api.open-meteo.com/v1/"
        case .geocode(_):
            "https://geocoding-api.open-meteo.com/v1/"
        }
    }
    
    var path: String {
        switch self {
        case .weather(_,_):
            "forecast"
        case .geocode(_):
            "search"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .weather(let lat, let lon):
            [
                URLQueryItem(name: "latitude", value: "\(lat)"),
                URLQueryItem(name: "longitude", value: "\(lon)"),
                URLQueryItem(name: "current", value: "temperature_2m"),
                URLQueryItem(name: "temperature_unit", value: "fahrenheit")
            ]
        case .geocode(let city):
            [
                URLQueryItem(name: "name", value: city),
                URLQueryItem(name: "count", value: "1")
            ]
        }
    }
}
