//
//  WeatherRepositoryImpl.swift
//  WeatherAsyncStream
//
//  Created by John Jones on 3/13/26.
//

import Foundation

final class WeatherRepositoryImpl: WeatherRepository {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchWeather(for location: String) -> AsyncThrowingStream<Weather, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let geoEndpoint: WeatherEndpoint = .geocode(city: location)
                    let geoResponse: GeoResponse = try await networkManager.request(endpoint: geoEndpoint)
                    
                    guard let result = geoResponse.results.first else {
                        throw WeatherError.locationNotFound
                    }
                    
                    let (lat, lon) = (result.latitude, result.longitude)
                    let weatherEndpoint: WeatherEndpoint = .weather(lat: lat, lon: lon)
                    let weatherResponse: WeatherResponse = try await networkManager.request(endpoint: weatherEndpoint)
                    
                    let weather = Weather(location: location, temperature: "\(weatherResponse.current.temp)")
                    continuation.yield(weather)
                    continuation.finish()
                } catch let error as WeatherError {
                    continuation.finish(throwing: error)
                } catch {
                    continuation.finish(throwing: WeatherError.networkFailure(error.localizedDescription))
                }
            }
        }
    }
}
