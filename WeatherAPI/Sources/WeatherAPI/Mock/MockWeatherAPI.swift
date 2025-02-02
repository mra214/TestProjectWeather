//
//  MockWeatherAPI.swift
//  WeatherAPI
//
//  Created by Rauf Mehdiyev on 2/1/25.
//

import Foundation

public final class MockWeatherAPI: WeatherAPI {
    
    private let data: [WeatherData]
    private let responseDelay: Duration
    
    public init(
        _ data: [WeatherData] = [
            WeatherData(
                id: "101",
                city: City(id: "city1", name: "The Woodlands"),
                temperature: 28,
                feelsLikeTemperature: 40,
                temperatureUnit: .celsius,
                humidity: 20,
                uvIndex: 4,
                icon: .local(systemName: "sun.max.fill")
            ),
            WeatherData(
                id: "102",
                city: City(id: "city2", name: "San Francisco"),
                temperature: 15,
                feelsLikeTemperature: 18,
                temperatureUnit: .celsius,
                humidity: 14,
                uvIndex: 5,
                icon: .local(systemName: "cloud.fill")
            ),
            WeatherData(
                id: "103",
                city: City(id: "city3", name: "Plano"),
                temperature: 26,
                feelsLikeTemperature: 32,
                temperatureUnit: .celsius,
                humidity: 18,
                uvIndex: 4,
                icon: .local(systemName: "sun.max.fill")
            )
        ],
        responseDelay: Duration = .seconds(1)
    ) {
        self.data = data
        self.responseDelay = responseDelay
    }
    
    public func searchCity(_ request: WeatherDataSearchCityRequest) async throws -> [WeatherData] {
        try? await Task.sleep(for: responseDelay)
        return data
    }
    
    public func fetch(_ request: WeatherDataFetchRequest) async throws -> WeatherData? {
        try? await Task.sleep(for: responseDelay)
        return data.first(where: {
            $0.city.name == request.cityName
        })
    }
}

