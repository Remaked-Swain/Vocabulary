//
//  SummaryWordCard.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/11/24.
//

import SwiftUI

struct SummaryWordCard: View {
    @Environment(\.userInterfaceIdiom) private var idiom
    
    private let word: Word
    
    init(_ word: Word) {
        self.word = word
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Text(word.text)
                .font(idiom == .pad ? .largeTitle : .headline)
                .bold()
            
            VStack(alignment: .leading, spacing: 20) {
                Text(word.reading)
                Text(word.meaning)
            }
            .font(idiom == .pad ? .title2 : .subheadline)
            .bold()
            .foregroundStyle(.secondary)
        }
    }
}
