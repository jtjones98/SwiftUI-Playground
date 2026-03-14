//
//  FetchWeatherUseCase.swift
//  WeatherCleanMVVM
//
//  Created by John Jones on 3/13/26.
//

import Foundation

class FetchWeatherUseCase {
    
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func fetchWeather(for location: String) async throws -> Weather {
        do {
            let weather = try await repository.fetchWeather(for: location)
            return weather
        } catch {
            print("Use case failed to fetch weather")
            throw error
        }
    }
}
