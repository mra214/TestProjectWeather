//
//  WeatherApiFactory.swift
//  WeatherApp
//
//  Created by Rauf Mehdiyev on 1/29/25.
//

import WeatherAPI
import WeatherAPIClient
import SwiftUI

public struct WeatherApiFactory {
    private static let apiKey: String = "8ea3859e7188416b86694231250102"
    
    public static func make() -> some WeatherAPI {
        WeatherAPIComClient(apiKey: apiKey)
    }
    
    public static func mock() -> some WeatherAPI {
        MockWeatherAPI()
    }
}
