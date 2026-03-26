//
//  WeatherViewModel.swift
//  WeatherCleanMVVM
//
//  Created by John Jones on 3/13/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class WeatherViewModel {
    
    private let fetchWeatherUseCase: FetchWeatherUseCase
    
    var weathers: [Weather] = []
    var searchText: String = ""
    
    init(useCase: FetchWeatherUseCase) {
        fetchWeatherUseCase = useCase
    }
    
    func fetchWeather(for location: String) async {
        do {
            let weather = try await fetchWeatherUseCase.fetchWeather(for: location)
            weathers.append(weather)
        } catch {
            print("View Model unable to fetch weather: \(error.localizedDescription)")
        }
    }
}
