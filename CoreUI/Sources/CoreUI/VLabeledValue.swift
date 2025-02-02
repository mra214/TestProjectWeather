//
//  VLabeledValue.swift
//  CoreUI
//
//  Created by Rauf Mehdiyev on 1/27/25.
//

import SwiftUI

public struct VLabeledValue<V: View>: View {
    public let spacing: CGFloat = 8
    public let label: Text
    public let value: V
    
    public init(
        _ label: LocalizedStringKey,
        value: V
    ) {
        self.label = Text(label)
        self.value = value
    }
    
    public var body: some View {
        VStack(spacing: spacing) {
            label
            value
        }
        .font(.caption)
        .foregroundStyle(Color.gray)
        .padding(6)
    }
}

#Preview {
    VLabeledValue("Label", value: Text("Value"))
}
