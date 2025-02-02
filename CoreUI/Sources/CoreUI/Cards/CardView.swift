//
//  CardView.swift
//  CoreUI
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

import SwiftUI

public struct CardView<Content: View>: View {
    public let content: Content
    
    public init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .bordered()
    }
}

#Preview {
    CardView {
        Text("Hello, World!")
    }
}
