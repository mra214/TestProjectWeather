//
//  WeatherData.swift
//  WeatherAPI
//
//  Created by Rauf Mehdiyev on 1/28/25.
//

import Foundation

public struct WeatherData: Codable, Hashable, Identifiable, Sendable {
    
    public enum TemperatureUnit: String, Codable, Sendable {
        case celsius
        case fahrenheit
    }
    
    public enum WeatherIcon: Codable, Hashable, Sendable {
        case local(systemName: String)
        case remote(URL)
    }
    
    public init(
        id: String,
        city: City,
        temperature: Double,
        feelsLikeTemperature: Double,
        temperatureUnit: TemperatureUnit,
        humidity: Double,
        uvIndex: Double,
        icon: WeatherIcon
    ) {
        self.id = id
        self.city = city
        self.temperature = temperature
        self.feelsLikeTemperature = feelsLikeTemperature
        self.temperatureUnit = temperatureUnit
        self.humidity = humidity
        self.uvIndex = uvIndex
        self.icon = icon
    }
    
    public let id: String
    public let city: City
    public let temperature: Double
    public let feelsLikeTemperature: Double
    public let temperatureUnit: TemperatureUnit
    public let humidity: Double
    public let uvIndex: Double
    public let icon: WeatherIcon
}

extension WeatherData.TemperatureUnit: CustomStringConvertible {
    public var description: String {
        switch self {
        case .celsius:
            "°"
        case .fahrenheit:
            "F"
        }
    }
}
