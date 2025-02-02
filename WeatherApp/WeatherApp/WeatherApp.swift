//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

import SwiftUI

import WeatherCore
import WeatherAPI

@main
struct WeatherApp: App {
    
    // TODO: Move to the dependency container.
    let homeScreenViewModel: HomeScreenViewModel = {
        #if DEBUG
        let weatherApi = WeatherApiFactory.make()
//        let weatherApi = WeatherApiFactory.mock()
        #else
        let weatherApi = WeatherApiFactory.make()
        #endif
        return .init(
            weatherDataViewModel: WeatherDetailsViewModel(
                apiClient: weatherApi
            ),
            citySearchViewModel: CitySearchListViewModel(
                apiClient: weatherApi
            )
        )
    }()
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(homeScreenViewModel)
        }
    }
}
