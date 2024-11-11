//
//  SummaryWordCard.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/11/24.
//

import SwiftUI

struct SummaryWordCard: View {
    private let word: Word
    
    init(_ word: Word) {
        self.word = word
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Text(word.text)
                .font(.largeTitle.bold())
            
            VStack(alignment: .leading, spacing: 20) {
                Text(word.reading)
                Text(word.meaning)
            }
            .font(.title2.bold())
            .foregroundStyle(.secondary)
        }
    }
}
