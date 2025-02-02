//
//  WeatherDetailsView.swift
//  WeatherCore
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

import SwiftUI
import CoreUI
import WeatherAPI

public struct WeatherDetailsView: View {
    @EnvironmentObject private var viewModel: WeatherDetailsViewModel
    
    public var body: some View {
        Group {
            switch viewModel.state {
            case .empty:
                emptyStateView
                
            case .needsReload:
                VStack {
                    EmptyView()// onAppear is not triggered with simply EmptyView
                }
                .onAppear() {
                    viewModel.updateWeatherData()
                }
                
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                
            case .error(let error):
                errorView(for: error) {
                    viewModel.updateWeatherData()
                }
                
            case .loaded(let weatherData):
                weatherDetailsView(for: weatherData)
            }
        }
        .onAppear {
            if case .needsReload = viewModel.state {
                viewModel.updateWeatherData()
            }
        }
    }
    
    private func weatherDetailsView(for data: WeatherData) -> some View {
        
        return VStack(spacing: 10) {
            Spacer()
            weatherIcon(for: data)
                .frame(
                    width: 120,
                    height: 120
                )
            city(for: data)
            temperature(for: data)
            otherDetails(for: data)
                .padding(
                    EdgeInsets(
                        top: 15,
                        leading: 50,
                        bottom: 8,
                        trailing: 50
                    )
                )
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        EmptyContentView(
            title: "No City Selected",
            subtitle: "Please Search For A City"
        ) {
            viewModel.updateWeatherData()
        }
    }
    
    private func errorView(for error: Error, action: (() -> ())? = nil) -> some View {
        EmptyContentView(
            title: "Error",
            subtitle: error.localizedDescription
        ) {
            action?()
        }
    }
    
    private func weatherIcon(for data: WeatherData) -> some View {
        Group {
            switch data.icon {
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
        .scaledToFit()
        .frame(
            width: 120,
            height: 120
        )
    }
    
    private func city(for data: WeatherData) -> some View {
        HStack {
            Text(data.city.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Image(systemName: "location.fill")
                .font(.title2)
        }
    }
    
    private func temperature(for data: WeatherData) -> some View {
        HStack {
            // TODO: Change font-name
            Text("\(data.temperature, specifier: "%.0f")")
                .font(
                    .system(
                        size: 72,
                        weight: .semibold,
                        design: .none
                    )
                )
            Text("\(data.temperatureUnit)")
                .font(.system(size: 26, weight: .light))
                .baselineOffset(46)
        }
    }
    
    private func otherDetails(for data: WeatherData) -> some View {
        HCardView {
            VLabeledValue(
                "Humidity",
                value: Text("\(data.humidity, specifier: "%.0f")%")
                    .font(.body)
            )
            Spacer()
            VLabeledValue(
                "UV",
                value: Text("\(data.uvIndex, specifier: "%.0f")%")
                    .font(.body)
            )
            Spacer()
            VLabeledValue(
                "Feels Like",
                value: Text("\(data.feelsLikeTemperature, specifier: "%.0f")\(data.temperatureUnit.description)")
                    .font(.body)
            )
        }
    }
}

#Preview {
    let vm = WeatherDetailsViewModel(
        apiClient: MockWeatherAPI()
    )
    WeatherDetailsView()
        .environmentObject(vm)
}
