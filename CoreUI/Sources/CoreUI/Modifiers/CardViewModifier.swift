//
//  CardViewModifier.swift
//  CoreUI
//
//  Created by Rauf Mehdiyev on 1/31/25.
//

import SwiftUI

public struct CardViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        CardView {
            content
        }
    }
}

extension View {
    public func card() -> some View {
        modifier(CardViewModifier())
    }
}
