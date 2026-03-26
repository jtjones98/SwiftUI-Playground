//
//  WeatherRepository.swift
//  WeatherAsyncStream
//
//  Created by John Jones on 3/13/26.
//

protocol WeatherRepository {
    func fetchWeather(for location: String) -> AsyncThrowingStream<Weather, Error>
}
