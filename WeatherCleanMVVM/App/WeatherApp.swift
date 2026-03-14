//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by John Jones on 3/13/26.
//

import SwiftUI

@main
struct WeatherApp: App {
    
    let container = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            WeatherView(viewModel: container.makeWeatherViewModel())
        }
    }
}
