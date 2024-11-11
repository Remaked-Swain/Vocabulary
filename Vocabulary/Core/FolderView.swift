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
    @State private var currentWordIndex: Int = 0
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
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        toggleDisplayMode()
                    } label: {
                        Text("복습 모드 종료")
                    }
                    
                    Button {
                        evaluateReview()
                    } label: {
                        Text("채점 및 결과 확인")
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
        .padding(.horizontal)
    }
    
    @ViewBuilder private func content(_ mode: DisplayMode) -> some View {
        switch mode {
        case .inReviewing:
            WordsReviewView(words: folder.words, isReviewCompleted: $isReviewCompleted)
        case .displayingGrid:
            displayingGrid
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
        withAnimation(.smooth) {
            if displayMode == .inReviewing {
                displayMode = .displayingGrid
            } else {
                displayMode = .inReviewing
            }
        }
        isReviewCompleted = false
    }
    
    func evaluateReview() {
        withAnimation(.smooth) {
            isReviewCompleted = true
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
