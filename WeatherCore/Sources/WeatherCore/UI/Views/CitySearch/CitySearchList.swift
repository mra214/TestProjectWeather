//
//  SwiftUIView.swift
//  WeatherCore
//
//  Created by Rauf Mehdiyev on 1/31/25.
//

import SwiftUI

import CoreUI
import WeatherAPI

public struct CitySearchList: View {
    @EnvironmentObject private var viewModel: CitySearchListViewModel
    @Environment(\.dismissSearch) private var dismissSearch
    
    public var body: some View {
        VStack {
            switch viewModel.state {
            case .empty:
                EmptyView()
                
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                
            case .error(let error):
                errorView(for: error)
                
            case .loaded(let list):
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(list) { data in
                            WeatherCard(weatherData: data)
                                .padding(
                                    .init(
                                        top: 0,
                                        leading: 20,
                                        bottom: 0,
                                        trailing: 20
                                    )
                                )
                                .onTapGesture {
                                    viewModel.selectedCity = data.city
                                    dismissSearch()
                                }
                        }
                    }
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private func errorView(for error: Error) -> some View {
        EmptyContentView(
            title: "Error",
            subtitle: error.localizedDescription
        )
    }
}

#Preview {
    let vm = CitySearchListViewModel(
        apiClient: MockWeatherAPI()
    )
    CitySearchList()
        .environmentObject(vm)
}
