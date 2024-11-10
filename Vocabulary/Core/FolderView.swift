//
//  FolderView.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import SwiftUI

struct FolderView: View {
    private let folder: Folder
    
    private let columns = [GridItem](repeating: .init(.flexible(), spacing: 20), count: 3)
    
    @State private var displayMode: DisplayMode = .displayingGrid
    @State private var reviewStateText: String = String()
    @State private var currentWordIndex: Int = 0
    @State private var reviewResults: [String: ReviewResult] = [:]
    @State private var isReviewCompleted: Bool = false
    @State private var isAlertPresented: Bool = false
    
    init(_ folder: Folder) {
        self.folder = folder
    }
    
    var body: some View {
        VStack {
            content(displayMode)
        }
        .padding()
        .toolbar {
            switch displayMode {
            case .inReviewing:
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        toggleDisplayMode()
                    } label: {
                        Text("복습 모드 종료")
                    }
                }
            case .displayingGrid:
                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink {
                        WordEditView(folder: folder, word: nil)
                    } label: {
                        Label("단어 추가", systemImage: "plus")
                    }
                    
                    Menu {
                        Button {
                            sortWord(option: .alphabetically)
                        } label: {
                            Text("사전순 정렬")
                        }
                        
                        Button {
                            sortWord(option: .leastFrequentlyReviewed)
                        } label: {
                            Text("적게 본 단어순 정렬")
                        }
                    } label: {
                        Label("정렬하기", systemImage: "slider.horizontal.3")
                    }
                    
                    Button {
                        guard folder.words.isEmpty == false else {
                            isAlertPresented = true
                            return
                        }
                        toggleDisplayMode()
                    } label: {
                        Label("복습하기", systemImage: "play.fill")
                    }
                }
            }
        }
        .navigationTitle(folder.name)
        .alert("단어장이 비어있어요!", isPresented: $isAlertPresented) {
            Button {
                isAlertPresented = false
            } label: {
                Text("확인")
            }
        } message: {
            Text("단어를 추가해야 합니다.")
        }
    }
    
    private var displayingGrid: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(folder.words) { word in
                    WordCard(word)
                }
            }
        }
    }
    
    private var isReviewing: some View {
        VStack {
            if isReviewCompleted {
                reviewResultsView
            } else {
                currentReviewWordView
            }
        }
    }
    
    private var currentReviewWordView: some View {
        VStack {
            let word = folder.words[currentWordIndex]
            let showingSide = ShowingSide.random()
            
            if currentWordIndex < folder.words.count {
                VStack(spacing: 10) {
                    Spacer()
                    
                    if showingSide == .foreground {
                        Text(word.text)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text(word.reading)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    } else {
                        Text(word.reading)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text(word.meaning)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    HStack {
                        TextField("원문 또는 의미 작성", text: $reviewStateText)
                            .handwritableTextFieldStyle()
                        
                        Button("제출") {
                            submitAnswer(word: word, showingSide: showingSide)
                        }
                        .bigButtonStyle()
                        .disabled(reviewStateText.isEmpty)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                Text("모든 단어를 살펴보았습니다.\n시험을 종료하여 결과를 확인해주세요.")
            }
        }
    }
    
    private var reviewResultsView: some View {
        VStack {
            Text("결과")
                .font(.title)
                .padding()
            
            List {
                ForEach(folder.words) { word in
                    HStack {
                        VStack(spacing: 20) {
                            Text(word.text)
                            Text(word.reading)
                            Text(word.meaning)
                        }
                        
                        Spacer()
                        
                        if let reviewResult = reviewResults[word.text] {
                            Text(reviewResult.submittedAnswer ?? "없음")
                                .font(.headline.bold())
                                .foregroundStyle(reviewResult.isCorrect ? .green : .red)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func content(_ mode: DisplayMode) -> some View {
        switch mode {
        case .inReviewing:
            isReviewing
        case .displayingGrid:
            displayingGrid
        }
    }
    
    private func submitAnswer(word: Word, showingSide: ShowingSide) {
        let reviewResult = ReviewResult
            .build(word: word, showingSide: showingSide)
            .submitAnswer(reviewStateText)
        
        
        reviewResults[word.text] = reviewResult
        reviewStateText.removeAll()
        currentWordIndex += 1
        word.reviewCount += 1
        
        if currentWordIndex >= folder.words.count {
            isReviewCompleted = true
        }
    }
}

#Preview {
    NavigationStack {
        FolderView(.init(name: "새 폴더"))
            .modelContainer(for: [Word.self, Folder.self], inMemory: true)
    }
}

// MARK: Nested Types
extension FolderView {
    enum DisplayMode {
        case inReviewing
        case displayingGrid
    }
    
    func toggleDisplayMode() {
        isReviewCompleted = false
        if displayMode == .inReviewing {
            displayMode = .displayingGrid
        } else {
            displayMode = .inReviewing
        }
    }
    
    enum SortOption {
        /// 사전순 정렬
        case alphabetically
        /// 적게 본 단어순 정렬
        case leastFrequentlyReviewed
    }
    
    func sortWord(option: SortOption) {
        withAnimation(.bouncy) {
            switch option {
            case .alphabetically:
                folder.words.sort(by: {$0.text < $1.text})
            case .leastFrequentlyReviewed:
                folder.words.sort(by: {$0.reviewCount < $1.reviewCount})
            }
        }
    }
}
