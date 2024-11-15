//
//  Item.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import Foundation
import SwiftData

@Model
class Word {
    var text: String
    var reading: String
    private(set) var meanings: [String]
    var explanation: String?
    var meaning: String {
        get { meanings.joined(separator: ", ") }
        set { meanings = processMultipleMeanings(newValue) }
    }
    var folder: Folder
    var reviewCount: Int = 0
    var isReviewed: Bool { reviewCount > 3 }
    
    init(
        text: String,
        reading: String,
        meaning: String,
        explanation: String? = nil,
        in folder: Folder
    ) {
        self.text = text
        self.reading = reading
        self.meanings = []
        self.explanation = explanation
        self.folder = folder
        self.meaning = meaning
    }
    
    private func processMultipleMeanings(_ input: String) -> [String] {
        input
            .split(separator: ",", omittingEmptySubsequences: true) // 쉼표 분리, 빈 요소 제거
            .map { $0.trimmingCharacters(in: .whitespaces) } // 각 요소 앞뒤 공백 제거
            .filter { $0.isEmpty == false } // 빈 문자열 제거
    }
}
