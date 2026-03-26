//
//  FetchWeatherUseCase.swift
//  WeatherAsyncStream
//
//  Created by John Jones on 3/13/26.
//

import Foundation

class FetchWeatherUseCase {
    
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func fetchWeather(for location: String) -> AsyncThrowingStream<Weather, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    for try await weather in repository.fetchWeather(for: location) {
                        continuation.yield(weather)
                    }
                    continuation.finish()
                } catch {
                    print("Use case failed to fetch weather")
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
