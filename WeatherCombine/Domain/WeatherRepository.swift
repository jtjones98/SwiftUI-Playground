//
//  WeatherRepository.swift
//  WeatherCombine
//
//  Created by John Jones on 3/13/26.
//

import Combine

protocol WeatherRepository {
    func fetchWeather(for location: String) -> AnyPublisher<Weather, Error>
}
