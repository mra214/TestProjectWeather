//
//  CitySelectionRepository.swift
//  WeatherRepository
//
//  Created by Rauf Mehdiyev on 1/29/25.
//

import WeatherAPI

public protocol CitySelectionRepository {
    func save(_ city: City)
    func get() -> City?
    func clear()
}
