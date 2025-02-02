//
//  WeatherAPIProtocol.swift
//  WeatherAPI
//
//  Created by Rauf Mehdiyev on 1/28/25.
//

import Foundation

public protocol WeatherAPI: Sendable {
    func searchCity(_ request: WeatherDataSearchCityRequest) async throws -> [WeatherData]
    func fetch(_ request: WeatherDataFetchRequest) async throws -> WeatherData?
}

public struct WeatherDataSearchCityRequest {
    public let query: String
    public let locale: Locale
    
    public init(query: String, locale: Locale = .current) {
        self.query = query
        self.locale = locale
    }
}

public struct WeatherDataFetchRequest: Sendable {
    public let cityName: String
    public let locale: Locale
    
    public init(cityName: String, locale: Locale = .current) {
        self.cityName = cityName
        self.locale = locale
    }
}

extension WeatherDataFetchRequest {
    public init(_ city: City) {
        self.init(
            cityName: city.name
        )
    }
}
