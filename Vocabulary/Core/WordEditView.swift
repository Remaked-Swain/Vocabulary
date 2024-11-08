//
//  WordEditView.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/7/24.
//

import SwiftUI

struct WordEditView: View {
    private let folder: Folder
    private let word: Word?
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var originalText: String = String()
    @State private var reading: String = String()
    @State private var meaning: String = String()
    
    private var textFieldIsEmpty: Bool {
        originalText.isEmpty || reading.isEmpty || meaning.isEmpty
    }
    
    init(
        folder: Folder,
        word: Word? = nil
    ) {
        self.folder = folder
        self.word = word
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("원문", text: $originalText)
                .handwritableTextFieldStyle()
            
            Spacer()
            
            TextField("읽는 방법", text: $reading)
                .handwritableTextFieldStyle()
            
            Spacer()
            
            TextField("의미", text: $meaning)
                .handwritableTextFieldStyle()
            
            Spacer()
            
            HStack {
                Button {
                    initializeReviewCount()
                } label: {
                    Text("복습 횟수 초기화")
                        .font(.headline)
                }
                .disabled(word?.isReviewed ?? true)
                
                Spacer()
                
                Button {
                    guard let word  = word else {
                        createWord()
                        return
                    }
                    updateWord(word: word)
                } label: {
                    Text("저장")
                        .font(.headline)
                }
                .disabled(textFieldIsEmpty)
            }
        }
        .padding()
        .safeAreaPadding()
        .onAppear {
            if let word = word {
                originalText = word.text
                reading = word.reading
                meaning = word.meaning
            }
        }
    }
    
    private func createWord() {
        let newWord = Word(text: originalText, reading: reading, meaning: meaning, in: folder)
        folder.words.append(newWord)
        dismiss()
    }
    
    private func updateWord(word: Word) {
        word.text = originalText
        word.reading = reading
        word.meaning = meaning
        dismiss()
    }
    
    private func initializeReviewCount() {
        word?.reviewCount = .zero
    }
}
