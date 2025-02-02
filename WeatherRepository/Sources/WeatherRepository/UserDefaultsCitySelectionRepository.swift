//
//  UserDefaultsCitySelectionRepository.swift
//  WeatherRepository
//
//  Created by Rauf Mehdiyev on 1/29/25.
//

import Foundation
import WeatherAPI

public class UserDefaultsCitySelectionRepository: CitySelectionRepository {
    private static let userDefaultsKeySelectedCity = "user-selected-city"
    private let userDefaults: UserDefaults
    
    public init(_ userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func save(_ city: City) {
        userDefaults.set(
            try? PropertyListEncoder().encode(city),
            forKey: Self.userDefaultsKeySelectedCity
        )
    }
    
    public func clear() {
        userDefaults.removeObject(forKey: Self.userDefaultsKeySelectedCity)
    }
    
    public func get() -> City? {
        guard
            let data = userDefaults.value(
                forKey: Self.userDefaultsKeySelectedCity
            ) as? Data
        else {
            return nil
        }
        guard
            let city = try? PropertyListDecoder().decode(
                City.self,
                from: data
            )
        else {
            return nil
        }
        return city
    }
}
