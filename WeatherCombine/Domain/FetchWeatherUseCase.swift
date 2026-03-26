//
//  FetchWeatherUseCase.swift
//  WeatherCombine
//
//  Created by John Jones on 3/13/26.
//

import Combine

class FetchWeatherUseCase {
    
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func fetchWeather(for location: String) -> AnyPublisher<Weather, Error> {
        repository.fetchWeather(for: location)
            .handleEvents(receiveCompletion: { completion in
                if case .failure = completion {
                    print("Use case failed to fetch weather")
                }
            })
            .eraseToAnyPublisher()
    }
}
