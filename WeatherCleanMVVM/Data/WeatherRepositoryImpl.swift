//
//  WeatherRepositoryImpl.swift
//  WeatherCleanMVVM
//
//  Created by John Jones on 3/13/26.
//

import Foundation

final class WeatherRepositoryImpl: WeatherRepository {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchWeather(for location: String) async throws -> Weather {
        do {
            let geoEndpoint: WeatherEndpoint = .geocode(city: location)
            let geoResponse: GeoResponse = try await networkManager.request(endpoint: geoEndpoint)
            
            guard let result = geoResponse.results.first else {
                throw WeatherError.locationNotFound
            }
            
            let (lat, lon) = (result.latitude, result.longitude)
            let weatherEndpoint: WeatherEndpoint = .weather(lat: lat, lon: lon)
            let weatherResponse: WeatherResponse = try await networkManager.request(endpoint: weatherEndpoint)
            
            return Weather(location: location, temperature: "\(weatherResponse.current.temp)")
        } catch let error as WeatherError {
            throw error
        } catch {
            throw WeatherError.networkFailure(error.localizedDescription)
        }
    }
}
