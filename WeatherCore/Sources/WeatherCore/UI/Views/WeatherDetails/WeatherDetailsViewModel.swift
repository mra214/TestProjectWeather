//
//  WeatherDetailsViewModel.swift
//  WeatherCore
//
//  Created by Rauf Mehdiyev on 1/31/25.
//

import Foundation
import Combine

import WeatherAPI
import WeatherAPIClient
import WeatherRepository

@MainActor
public class WeatherDetailsViewModel: ObservableObject {
    
    public enum State {
        case empty
        case needsReload
        case loading
        case loaded(WeatherData)
        case error(Error)
    }
    
    private let apiClient: WeatherAPI
    private let repository: CitySelectionRepository
    
    @Published public var selectedCity: City? {
        didSet {
            if let city = oldValue {
                repository.save(city)
                state = .needsReload
            } else {
//                repository.clear()
//                state = .empty
            }
        }
    }
    @Published public private(set) var state: State
    
    public init(
        apiClient: WeatherAPI,
        repository: CitySelectionRepository = UserDefaultsCitySelectionRepository()
    ) {
        self.apiClient = apiClient
        self.repository = repository
        if let savedCity = repository.get() {
            self._selectedCity = Published(initialValue: savedCity)
            self.state = .needsReload
            print("Loading Saved city")
        } else {
            self.state = .empty
            print("No City saved")
        }
    }
    
    private var currentTask: Task<Void, Error>?
    
    public func updateWeatherData() {
        currentTask?.cancel()
        
        guard let city = selectedCity else {
            state = .empty
            return
        }

        state = .loading
        
        currentTask = Task { [weak self] in
            do {
                let result = try await self?.apiClient.fetch(
                    .init(city)
                )
                if let result = result, !Task.isCancelled {
                    self?.state = .loaded(result)
                }
            } catch {
                if !Task.isCancelled {
                    self?.state = .error(error)
                }
            }
        }
    }
}
