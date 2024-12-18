//
//  WordCard.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/7/24.
//

import SwiftUI

struct WordCard: View {
    @Environment(\.userInterfaceIdiom) private var idiom
    @State private var showingSide: ShowingSide = .foreground
    
    private let word: Word
    
    init(_ word: Word) {
        self.word = word
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if showingSide == .foreground {
                Text(word.text)
                    .font(idiom == .pad ? .title2 : .headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(Constants.defaultLineLimit)
                
                Text(word.reading)
                    .font(idiom == .pad ? .title3 : .subheadline)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(Constants.defaultLineLimit)
            } else {
                Text(word.meaning)
                    .font(idiom == .pad ? .title3 : .headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(Constants.defaultLineLimit)
                
                Text(word.explanation ?? String())
                    .font(idiom == .pad ? .title3 : .subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(Constants.defaultLineLimit)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.ultraThickMaterial)
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
