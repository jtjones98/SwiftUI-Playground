//
//  WeatherRepository.swift
//  WeatherCleanMVVM
//
//  Created by John Jones on 3/13/26.
//

protocol WeatherRepository {
    func fetchWeather(for location: String) async throws -> Weather
}
