//
//  ReviewResult.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/9/24.
//

import Foundation

final class ReviewResult {
    private let word: Word
    private let showingSide: ShowingSide
    var submittedAnswer: String?
    var isCorrect: Bool {
        guard let submittedAnswer = submittedAnswer else { return false }
        
        switch showingSide {
        case .foreground:
            return word.meaning == submittedAnswer
        case .background:
            return word.text == submittedAnswer
        }
    }
    
    private init(word: Word, showingSide: ShowingSide) {
        self.word = word
        self.showingSide = showingSide
    }
    
    static func build(word: Word, showingSide: ShowingSide) -> ReviewResult {
        return .init(word: word, showingSide: showingSide)
    }
    
    func submitAnswer(_ answer: String) -> ReviewResult {
        self.submittedAnswer = answer
        return self
    }
}
