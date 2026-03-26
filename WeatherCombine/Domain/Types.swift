//
//  Types.swift
//  WeatherCombine
//
//  Created by John Jones on 3/13/26.
//

import Foundation

struct Weather: Identifiable {
    let id: UUID = UUID()
    let location: String
    let temperature: String
}

enum WeatherError: Error, LocalizedError {
    case locationNotFound
    case networkFailure(String)
    
    var errorDescription: String? {
        switch self {
        case .locationNotFound:
            "Location not found"
        case .networkFailure(let message):
            message
        }
    }
}
