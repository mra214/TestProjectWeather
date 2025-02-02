//
//  HomeScreenViewModel.swift
//  WeatherCore
//
//  Created by Rauf Mehdiyev on 1/31/25.
//

import SwiftUI
import Combine

@MainActor
public final class HomeScreenViewModel: ObservableObject {
    public let weatherDetailsViewModel: WeatherDetailsViewModel
    public let citySearchViewModel: CitySearchListViewModel
    
    @Published public var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        weatherDataViewModel: WeatherDetailsViewModel,
        citySearchViewModel: CitySearchListViewModel
    ) {
        self.weatherDetailsViewModel = weatherDataViewModel
        self.citySearchViewModel = citySearchViewModel
        
        // MARK: Bind search text
        $searchText
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.citySearchViewModel.searchQuery = searchText
            }
            .store(in: &cancellables)
        
        // MARK: Bind selected city
        citySearchViewModel
            .$selectedCity
            .removeDuplicates()
            .sink { [weak self] city in
                if let city {
                    self?.weatherDetailsViewModel.selectedCity = city
                }
            }
            .store(in: &cancellables)
    }
}
