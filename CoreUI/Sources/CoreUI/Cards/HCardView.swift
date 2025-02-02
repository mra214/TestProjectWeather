//
//  HCardView.swift
//  CoreUI
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

import SwiftUI

public struct HCardView<Content: View>: View {
    public let spacing: CGFloat = 8
    public let content: Content
    
    public init(
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content()
    }
    
    public var body: some View {
        HStack {
            content
        }
        .padding(
            .init(
                top: 8,
                leading: 4,
                bottom: 4,
                trailing: 8
            )
        )
        .card()
    }
}

#Preview {
    HCardView {
        VLabeledValue(
            "Humidity",
            value: Text("20%")
        )
        Spacer()
        VLabeledValue(
            "UV",
            value: Text("4")
        )
        Spacer()
        VLabeledValue(
            "Feels Like",
            value: Text("38º")
        )
    }
    .frame(width: 300)
}
