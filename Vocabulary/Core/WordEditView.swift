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
        List {
            if let word = word {
                HStack {
                    SummaryWordCard(word)
                        .padding()
                }
                .containerRelativeFrame(.horizontal, alignment: .center)
                .listRowSeparator(.hidden)
            }
            
            TextField("원문", text: $originalText)
                .handwritableTextFieldStyle()
                .listRowSeparator(.hidden)
            
            TextField("발음", text: $reading)
                .handwritableTextFieldStyle()
                .listRowSeparator(.hidden)
            
            TextField("의미 (쉼표로 구분해 작성할 수 있어요.)", text: $meaning)
                .handwritableTextFieldStyle()
                .listRowSeparator(.hidden)
            
            TextField("부가설명", text: $explanation)
                .handwritableTextFieldStyle()
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .safeAreaPadding()
        .onAppear {
            if let word = word {
                originalText = word.text
                reading = word.reading
                meaning = word.meaning
                explanation = word.explanation ?? String()
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    // MARK: 추후 기능 추가 예정 WIP
//                    Button(role: .destructive) {
//                        initializeReviewCount()
//                    } label: {
//                        Text("복습 횟수 초기화")
//                            .font(.headline)
//                    }
//                    .disabled(word?.isReviewed == false)
                    
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
        
//        WordEditView(folder: .init(name: "folder"), word: .init(text: "new word", reading: "new word reading", meaning: "new word meaning", in: .init(name: "folder")))
//            .environment(\.locale, .init(identifier: "ko"))
    }
}
