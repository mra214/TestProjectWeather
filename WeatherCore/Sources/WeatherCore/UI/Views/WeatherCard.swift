//
//  WeatherCard.swift
//  WeatherCore
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

import SwiftUI

import CoreUI
import WeatherAPI

public struct WeatherCard: View {
    private var weatherData: WeatherData
    
    public init(weatherData: WeatherData) {
        self.weatherData = weatherData
    }
    
    public var body: some View {
        HStack {
            VStack {
                city
                temperature
            }
            .padding(.top, 8)
            Spacer()
            weatherIcon
        }
        .padding(
            .init(
                top: 4,
                leading: 8,
                bottom: 4,
                trailing: 8
            )
        )
        .card()
        
    }
    
    private var city: some View {
        Text(weatherData.city.name)
            .font(.title2)
            .fontWeight(.semibold)
    }
    
    private var temperature: some View {
        HStack {
            // TODO: Change font-name
            Text("\(weatherData.temperature, specifier: "%.0f")")
                .font(
                    .system(
                        size: 64,
                        weight: .semibold,
                        design: .none
                    )
                )
            Text(weatherData.temperatureUnit.description)
                .font(.system(size: 24, weight: .light))
                .baselineOffset(36)
        }
    }
    
    private var weatherIcon: some View {
        Group {
            switch weatherData.icon {
            case .local(let systemName):
                Image(systemName: systemName)
                    .resizable()
            case .remote(let url):
                AsyncImage(url: url) { result in
                    result.image?
                        .resizable()
                }
            }
        }
        .scaledToFill()
        .frame(
            width: 120,
            height: 120
        )
    }
}

#Preview {
    let weatherData = WeatherData(
        id: "abc",
        city: City(id: "dfg", name: "Sugar Land"),
        temperature: 28,
        feelsLikeTemperature: 30,
        temperatureUnit: .celsius,
        humidity: 20,
        uvIndex: 14,
        //icon: .local(systemName: "cloud.fill")
        icon: .remote(
            .init(string: "https://cdn.weatherapi.com/weather/64x64/day/116.png")!
        )
    )
    
    WeatherCard(
        weatherData: weatherData
    )
    .frame(
        width: 350,
        height: 100
    )
}
