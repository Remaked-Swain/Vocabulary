//
//  ReviewResult.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/9/24.
//

import Foundation

final class ReviewResult {
    let word: Word
    let showingSide: ShowingSide
    var submittedAnswer: String = "-"
    var isCorrect: Bool = false
    
    private init(word: Word) {
        self.word = word
        self.showingSide = ShowingSide.random()
    }
    
    private func evaluateAnswer() {
        switch showingSide {
        case .foreground:
            isCorrect = word.meaning == submittedAnswer
        case .background:
            isCorrect = word.text == submittedAnswer
        }
    }
    
    static func build(word: Word) -> ReviewResult {
        return .init(word: word)
    }
    
    func submitAnswer(_ answer: String) {
        self.submittedAnswer = answer
        evaluateAnswer()
    }
    
    func adjustCorrection(to state: CorrectionState) {
        self.isCorrect = state == .correct ? true : false
    }
}

// MARK: Nested Types
extension ReviewResult {
    enum CorrectionState {
        case correct
        case incorrect
    }
}
