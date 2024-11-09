//
//  BigButtonStyle.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/9/24.
//

import SwiftUI

struct BigButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.title.bold())
            .background(configuration.isPressed ? .gray.opacity(0.3) : .accentColor)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 14))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.bouncy, value: configuration.isPressed)
    }
}

extension View {
    func bigButtonStyle() -> some View {
        self.buttonStyle(BigButtonStyle())
    }
}
