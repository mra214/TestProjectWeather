//
//  ComponentState.swift
//  WeatherApp
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

public protocol ComponentState: AnyObject, ComponentEventHandler {
    associatedtype Context = AnyObject
    
    var context: Context! { get }
    func setContext(_ context: Context)
    init(_ context: Context)
}
