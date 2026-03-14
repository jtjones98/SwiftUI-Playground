//
//  NetworkManager.swift
//  WeatherCleanMVVM
//
//  Created by John Jones on 3/13/26.
//

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
    func request<T: Decodable>(endpoint: WeatherEndpoint) async throws -> T
}

final class NetworkManagerImpl: NetworkManager {
    
    private let session: URLSession = .shared
    
    func request<T: Decodable>(endpoint: WeatherEndpoint) async throws -> T {
        
        guard var components = URLComponents(string: endpoint.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = endpoint.queryItems
        components.scheme = "https"
        components.path += endpoint.path
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(nil)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
