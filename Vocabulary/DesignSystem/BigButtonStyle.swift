//
//  BigButtonStyle.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/9/24.
//

import SwiftUI

struct BigButtonStyle: ButtonStyle {
    private let idiom: UIUserInterfaceIdiom
    private let background: Color
    
    init(idiom: UIUserInterfaceIdiom, background: Color) {
        self.idiom = idiom
        self.background = background
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(idiom == .pad ? .title : .headline)
            .bold()
            .background(configuration.isPressed ? .gray.opacity(0.3) : background)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 14))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.bouncy, value: configuration.isPressed)
    }
}

extension View {
    func bigButtonStyle(_ background: Color = .accentColor, _ idiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom) -> some View {
        self.buttonStyle(BigButtonStyle(idiom: idiom, background: background))
    }
}
