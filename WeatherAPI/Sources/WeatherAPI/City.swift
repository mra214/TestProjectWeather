//
//  City.swift
//  WeatherAPI
//
//  Created by Rauf Mehdiyev on 1/28/25.
//

public struct City: Codable, Hashable, Identifiable, Sendable {
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    public let id: String
    public let name: String
}
