//
//  BorderedViewModifier.swift
//  CoreUI
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

import SwiftUI

public struct BorderedViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(
                .init(
                    top: 8,
                    leading: 16,
                    bottom: 8,
                    trailing: 16
                )
            )
            .background(
                Color.lightGray
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 12
                )
            )
            .shadow(
                color: Color.lightGray,
                radius: 1,
                x: 1,
                y: 2
            )
    }
}

extension View {
    public func bordered() -> some View {
        ModifiedContent(
            content: self,
            modifier: BorderedViewModifier()
        )
    }
}
