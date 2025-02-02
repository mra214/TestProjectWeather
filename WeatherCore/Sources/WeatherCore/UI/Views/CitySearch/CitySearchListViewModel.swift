//
//  CitySearchListViewModel.swift
//  WeatherCore
//
//  Created by Rauf Mehdiyev on 1/31/25.
//

import Foundation
import Combine

import WeatherAPI
import WeatherAPIClient

@MainActor
public class CitySearchListViewModel: ObservableObject {
    
    public enum State {
        case empty
        case loading
        case loaded([WeatherData])
        case error(Error)
    }
    
    private let apiClient: WeatherAPI
    
    @Published public var selectedCity: City?
    @Published public var searchQuery: String = ""
    private var cancellable = Set<AnyCancellable>()
    @Published public private(set) var state: State = .empty
    
    public init(
        apiClient: WeatherAPI
    ) {
        self.apiClient = apiClient
        
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] searchTerm in
                self?.performSearch(for: searchTerm)
                }
            )
            .store(in: &cancellable)
    }
    
    private var currentSearchTask: Task<Void, Error>?
    
    private func performSearch(for term: String) {
        currentSearchTask?.cancel()
        
        guard !term.isEmpty else {
            self.state = .empty
            return
        }
        
        state = .loading
        
        currentSearchTask = Task { [weak self] in
            do {
                let fetchedResults = try await self?.apiClient.searchCity(
                    .init(query: term)
                )
                
                if let results = fetchedResults, !Task.isCancelled {
                    self?.state = .loaded(results)
                }
            } catch {
                if !Task.isCancelled {
                    self?.state = .error(error)
                }
            }
        }
    }
}
