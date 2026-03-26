//
//  WeatherRepositoryImpl.swift
//  WeatherCombine
//
//  Created by John Jones on 3/13/26.
//

import Combine
import Foundation

final class WeatherRepositoryImpl: WeatherRepository {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchWeather(for location: String) -> AnyPublisher<Weather, Error> {
        let geoEndpoint: WeatherEndpoint = .geocode(city: location)
        
        let geoPublisher: AnyPublisher<GeoResponse, Error> = networkManager.request(endpoint: geoEndpoint)
        
        return geoPublisher
            .tryMap { geoResponse in
                guard let result = geoResponse.results.first else {
                    throw WeatherError.locationNotFound
                }
                return (result.latitude, result.longitude)
            }
            .flatMap { lat, lon in
                let weatherEndpoint: WeatherEndpoint = .weather(lat: lat, lon: lon)
                let weatherPublisher: AnyPublisher<WeatherResponse, Error> = self.networkManager.request(endpoint: weatherEndpoint)
                return weatherPublisher
            }
            .map { weatherResponse in
                Weather(location: location, temperature: "\(weatherResponse.current.temp)")
            }
            .mapError { error in
                (error as? WeatherError) ?? WeatherError.networkFailure(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
