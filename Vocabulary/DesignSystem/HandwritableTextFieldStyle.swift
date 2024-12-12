//
//  TextFieldStyle.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/7/24.
//

import SwiftUI

struct HandwritableTextFieldStyle: ViewModifier {
    private let idiom: UIUserInterfaceIdiom
    
    init(idiom: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom) {
        self.idiom = idiom
    }
    
    func body(content: Content) -> some View {
        content
            .padding()
            .font(idiom == .pad ? .title : .headline)
            .bold()
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: 14))
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

extension View {
    func handwritableTextFieldStyle() -> some View {
        self.modifier(HandwritableTextFieldStyle())
    }
}
