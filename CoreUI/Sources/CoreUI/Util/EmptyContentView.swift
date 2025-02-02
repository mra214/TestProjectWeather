//
//  EmptyContentView.swift
//  CoreUI
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

import SwiftUI

public struct EmptyContentView: View {
    public enum ImageSource {
        case system(imageName: String)
        case asset(imageName: String)// TODO: Add bundle
        case url(URL)
    }
    
    private let title: String?
    private let subtitle: String?
    private let imageSource: ImageSource?
    private var action: (() -> Void)? = nil
    
    public init(
        title: String,
        subtitle: String,
        image: ImageSource? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageSource = image
        self.action = action
    }
    
    public init(
        title: String,
        image: ImageSource?,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = nil
        self.imageSource = image
        self.action = action
    }
    
    public init(
        subtitle: String,
        image: ImageSource?,
        action: (() -> Void)? = nil
    ) {
        self.title = nil
        self.subtitle = subtitle
        self.imageSource = image
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            if let imageSource = imageSource {
                image(for: imageSource)
            }
            if let title = title {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            if let subtitle {
                Text(subtitle)
                    .font(.body)
            }
        }
        .onTapGesture {
            action?()
        }
    }
    
    private func image(for source: ImageSource) -> some View {
        Group {
            switch source {
            case .system(let imageName):
                Image(systemName: imageName)
                    .resizable()
            case .asset(let imageName):
                Image(imageName)
                    .resizable()
            case .url(let url):
                AsyncImage(url: url)
            }
        }
        .scaledToFit()
        .frame(
            width: 50,
            height: 50
        )
    }
}

#Preview {
    Group {
        EmptyContentView(
            title: "No City Selected",
            subtitle: "Please Search For A City"
        )
        
        Divider()
        
        EmptyContentView(
            title: "No Connection",
            subtitle: "Check your internet connection",
            image: .system(imageName: "network.slash")
        ) {
            print("Retry")
        }
        
        Divider()
        
        EmptyContentView(
            title: "No Connection",
            subtitle: "Check your internet connection",
            image: .url(
                .init(string: "https://cdn.weatherapi.com/weather/64x64/day/116.png"
                     )!
            )
        )
    }
}
