//
//  WordCard.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/7/24.
//

import SwiftUI

struct WordCard: View {
    private let word: Word
    
    @State private var showingSide: ShowingSide = .foreground
    
    init(_ word: Word) {
        self.word = word
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if showingSide == .foreground {
                Text(word.text)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Text(word.reading)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text(word.meaning)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .onTapGesture {
            flipShowingSide()
        }
        .contextMenu {
            Button(role: .destructive) {
                deleteWord(word: word)
            } label: {
                Label("삭제", systemImage: "trash")
            }
            
            NavigationLink {
                WordEditView(folder: word.folder, word: word)
            } label: {
                Label("수정", systemImage: "pencil.circle")
            }
        }
    }
    
    private func deleteWord(word: Word) {
        guard let index = word.folder.words.firstIndex(where: {$0.id == word.id}) else { return }
        word.folder.words.remove(at: index)
    }
    
    private func flipShowingSide() {
        withAnimation(.easeInOut) {
            if showingSide == .foreground {
                showingSide = .background
            } else {
                showingSide = .foreground
            }
        }
    }
}

// MARK: Nested Types
extension WordCard {
    enum ShowingSide {
        /// 단어의 원문과 읽는 방법이 노출되는 방향.
        case foreground
        /// 단어의 의미가 노출되는 방향.
        case background
    }
}
