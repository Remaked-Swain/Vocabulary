//
//  ShowingSide.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/9/24.
//

import Foundation

enum ShowingSide {
    /// 단어의 원문과 읽는 방법이 노출되는 방향.
    case foreground
    /// 단어의 의미가 노출되는 방향.
    case background
}

extension ShowingSide: CaseIterable {
    static func random() -> ShowingSide {
        guard let randomElement = Self.allCases.randomElement() else {
            fatalError("No case in ShowingSide")
        }
        return randomElement
    }
}
