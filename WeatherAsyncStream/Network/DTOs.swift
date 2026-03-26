//
//  DTOs.swift
//  WeatherAsyncStream
//
//  Created by John Jones on 3/13/26.
//

import Foundation

struct GeoResponse: Decodable {
    let results: [GeoResult]
}

struct GeoResult: Decodable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
}

struct WeatherResponse: Decodable {
    let current: CurrentWeather
}

struct CurrentWeather: Decodable {
    let temp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp = "temperature_2m"
    }
}
