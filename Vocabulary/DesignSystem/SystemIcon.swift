//
//  SystemIcon.swift
//  Vocabulary
//
//  Created by Swain Yun on 12/2/24.
//

import SwiftUI

enum SystemIcon: String {
    case stopReviewing = "stop.circle"
    case retryReviewWithIncorrectAnswers = "exclamationmark.triangle"
    case retryReview = "shuffle"
    case flipAndRetryReview = "arrow.left.and.right"
    case evaluateReview = "checkmark.circle"
    
    var title: String {
        switch self {
        case .stopReviewing:
            "종료"
        case .retryReviewWithIncorrectAnswers:
            "틀린 문제만"
        case .retryReview:
            "모든 문제 섞어서"
        case .flipAndRetryReview:
            "반대로 뒤집어서"
        case .evaluateReview:
            "채점"
        }
    }
    
    var symbolName: String {
        self.rawValue
    }
}

extension Label where Title == Text, Icon == Image {
    init(systemIcon: SystemIcon) {
        self.init {
            Text(systemIcon.title)
        } icon: {
            Image(systemName: systemIcon.symbolName)
        }
    }
}
