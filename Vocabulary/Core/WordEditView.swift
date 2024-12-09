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
    @State private var explanation: String = String()
    
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
        ZStack {
            VStack(spacing: 40) {
                if let word = word {
                    SummaryWordCard(word)
                }
                
                TextField("원문", text: $originalText)
                    .handwritableTextFieldStyle()
                
                TextField("발음", text: $reading)
                    .handwritableTextFieldStyle()
                
                TextField("의미 (쉼표로 구분해 작성할 수 있어요.)", text: $meaning)
                    .handwritableTextFieldStyle()
                
                TextField("부가설명", text: $explanation)
                    .handwritableTextFieldStyle()
            }
            
            VStack {
                Spacer()
                
                HStack {
                    Button(role: .destructive) {
                        initializeReviewCount()
                    } label: {
                        Text("복습 횟수 초기화")
                            .font(.headline)
                    }
                    .disabled(word?.isReviewed == false)
                    
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
        let newWord = Word(
            text: originalText,
            reading: reading,
            meaning: meaning,
            explanation: explanation,
            in: folder
        )
        folder.words.append(newWord)
        clearTextField()
    }
    
    private func updateWord(word: Word) {
        word.text = originalText
        word.reading = reading
        word.meaning = meaning
        word.explanation = explanation
        dismiss()
    }
    
    private func initializeReviewCount() {
        word?.reviewCount = .zero
    }
    
    private func clearTextField() {
        originalText.removeAll()
        reading.removeAll()
        meaning.removeAll()
        explanation.removeAll()
    }
}

#Preview {
    Group {
        WordEditView(folder: .init(name: "folder"), word: .init(text: "new word", reading: "new word reading", meaning: "new word meaning", in: .init(name: "folder")))
            .environment(\.locale, .init(identifier: "en"))
        
        WordEditView(folder: .init(name: "folder"), word: .init(text: "new word", reading: "new word reading", meaning: "new word meaning", in: .init(name: "folder")))
            .environment(\.locale, .init(identifier: "ko"))
    }
}
