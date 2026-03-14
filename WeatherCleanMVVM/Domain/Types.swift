//
//  Types.swift
//  WeatherCleanMVVM
//
//  Created by John Jones on 3/13/26.
//

import Foundation

struct Weather: Identifiable {
    let id: UUID = UUID()
    let location: String
    let temperature: String
}

enum WeatherError: Error {
    case locationNotFound
}
