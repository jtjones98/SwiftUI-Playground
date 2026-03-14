//
//  DIContainer.swift
//  WeatherCleanMVVM
//
//  Created by John Jones on 3/13/26.
//

import Observation

@Observable
final class DIContainer {
    
    let networkManager = NetworkManagerImpl()
    
    @ObservationIgnored
    lazy var weatherRepository = WeatherRepositoryImpl(networkManager: networkManager)
    
    @ObservationIgnored
    lazy var fetchWeatherUseCase = FetchWeatherUseCase(repository: weatherRepository)
    
    func makeWeatherViewModel() -> WeatherViewModel {
        WeatherViewModel(useCase: fetchWeatherUseCase)
    }
}
