//
//  ContentView.swift
//  SwiftUIPlayground
//
//  Created by John Jones on 3/13/26.
//

import SwiftUI

struct WeatherView: View {
    
    let viewModel: WeatherViewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            List(viewModel.weathers) { weather in
                HStack {
                    Text(weather.location)
                    Spacer()
                    Text(weather.temperature)
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .onSubmit(of: .search) {
            Task {
                await viewModel.fetchWeather(for: viewModel.searchText)
            }
        }
    }
}

#Preview {
    WeatherView(viewModel: DIContainer().makeWeatherViewModel())
}
