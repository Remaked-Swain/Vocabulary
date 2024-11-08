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
        VStack(spacing: 20) {
            TextField("원문", text: $originalText)
                .handwritableTextFieldStyle()
            
            TextField("읽는 방법", text: $reading)
                .handwritableTextFieldStyle()
            
            TextField("의미", text: $meaning)
                .handwritableTextFieldStyle()
            
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
}
