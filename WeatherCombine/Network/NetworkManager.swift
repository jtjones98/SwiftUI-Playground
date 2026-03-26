//
//  NetworkManager.swift
//  WeatherCombine
//
//  Created by John Jones on 3/13/26.
//

import Combine
import Foundation

enum NetworkError: Error, CustomDebugStringConvertible {
    case invalidURL
    case invalidResponse(Int?)
    
    var debugDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse(let code):
            return (code != nil) ? "Invalid status code \(code!)" : "Invalid response"
        }
    }
}

protocol NetworkManager {
    func request<T: Decodable>(endpoint: WeatherEndpoint) -> AnyPublisher<T, Error>
}

final class NetworkManagerImpl: NetworkManager {
    
    private let session: URLSession = .shared
    
    func request<T: Decodable>(endpoint: WeatherEndpoint) -> AnyPublisher<T, Error> {
        
        guard var components = URLComponents(string: endpoint.baseURL) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        components.queryItems = endpoint.queryItems
        components.scheme = "https"
        components.path += endpoint.path
        
        guard let url = components.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse(nil)
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
