//
//  ComponentEventHandler.swift
//  WeatherApp
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

public protocol ComponentEventHandler {
    associatedtype Event
    
    func handle(_ event: Event) throws
}
