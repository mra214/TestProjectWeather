//
//  HomeScreen.swift
//  WeatherCore
//
//  Created by Rauf Mehdiyev on 1/31/25.
//

import SwiftUI
import WeatherAPI

public struct HomeScreen: View {
    
    @EnvironmentObject private var viewModel: HomeScreenViewModel

    public init() { }
    
    public var body: some View {
        NavigationStack {
            HomeView(viewModel: viewModel)
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer,
            prompt: LocalizedStringKey("Search Location")
        )
    }
}

fileprivate struct HomeView: View {
    @ObservedObject
    private var viewModel: HomeScreenViewModel
    @Environment(\.isSearching) private var isSearching
    
    init(viewModel: HomeScreenViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if isSearching {
            CitySearchList()
                .environmentObject(viewModel.citySearchViewModel)
        } else {
            WeatherDetailsView()
                .environmentObject(viewModel.weatherDetailsViewModel)
        }
    }
}

#Preview {
    let weatherApi = MockWeatherAPI()
    let vm = HomeScreenViewModel(
        weatherDataViewModel: WeatherDetailsViewModel(
            apiClient: weatherApi
        ),
        citySearchViewModel: CitySearchListViewModel(
            apiClient: weatherApi
        )
    )
    HomeScreen()
        .environmentObject(vm)
}
