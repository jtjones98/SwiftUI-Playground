//
//  WeatherViewModel.swift
//  WeatherCombine
//
//  Created by John Jones on 3/25/26.
//

import Combine
import Foundation
import Observation

@MainActor
@Observable
final class WeatherViewModel {
    
    private let fetchWeatherUseCase: FetchWeatherUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    var weathers: [Weather] = []
    var searchText: String = ""
    
    init(useCase: FetchWeatherUseCase) {
        fetchWeatherUseCase = useCase
    }
    
    func fetchWeather(for location: String) {
        fetchWeatherUseCase.fetchWeather(for: location)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("View Model unable to fetch weather: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] weather in
                    self?.weathers.append(weather)
                }
            )
            .store(in: &cancellables)
    }
}

