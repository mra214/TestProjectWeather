//
//  WeatherApiComClient+WeatherAPI.swift
//  WeatherApp
//
//  Created by Rauf Mehdiyev on 2/1/25.
//

import Foundation
import WeatherAPI

extension WeatherAPIComClient: WeatherAPI {

    public func searchCity(
        _ request: WeatherDataSearchCityRequest
    ) async throws -> [WeatherData] {
        let apiWeather = try await withThrowingTaskGroup(
            of: WeatherApiCom.CurrentWeather?.self,
            returning: [WeatherApiCom.CurrentWeather?].self
        ) { taskGroup in
            let locations = try await search(request.query)
            for location in locations {
                taskGroup.addTask { try await self.currentWeather(location.name) }
            }
            
            var apiWeather = [WeatherApiCom.CurrentWeather]()
            for try await result in taskGroup {
                if let result = result {
                    apiWeather.append(result)
                }
            }
            return apiWeather
        }
        return apiWeather
            .compactMap({ $0 })
            .map({ WeatherData(from: $0) })
    }
    
    public func fetch(
        _ request: WeatherDataFetchRequest
    ) async throws -> WeatherData? {
        guard let weather = try await currentWeather(request.cityName) else {
            return nil
        }
        return .init(from: weather)
    }
}

extension WeatherData {
    public init(
        from weatherData: WeatherApiCom.CurrentWeather
    ) {
        let iconUrl = URL(string: weatherData.current.condition.icon)
        self.init(
            id: weatherData.location.name,
            city: City(
                id: weatherData.location.name,
                name: weatherData.location.name
            ),
            temperature: weatherData.current.temp_c,
            feelsLikeTemperature: weatherData.current.feelslike_c,
            temperatureUnit: .celsius,
            humidity: weatherData.current.humidity,
            uvIndex: weatherData.current.uv,
            icon: iconUrl == nil ? .local(systemName: "photo") : .remote(iconUrl!)
        )
    }
}
