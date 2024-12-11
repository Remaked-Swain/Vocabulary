//
//  FolderView.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import SwiftUI

struct FolderView: View {
    @Environment(\.userInterfaceIdiom) var idiom
    
    private let folder: Folder
    
    private let columns = [GridItem](repeating: .init(.flexible(), spacing: 20), count: 3)
    
    @State private var displayMode: DisplayMode = .displayingGrid
    @State private var currentWordIndex: Int = 0
    @State private var isAlertPresented: Bool = false
    
    init(_ folder: Folder) {
        self.folder = folder
    }
    
    var body: some View {
        VStack {
            content(displayMode)
        }
        .padding()
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
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                if displayMode == .displayingGrid {
                    NavigationLink {
                        WordEditView(folder: folder, word: nil)
                    } label: {
                        Label("단어 추가", systemImage: "plus")
                    }
                    
                    Button {
                        guard folder.words.isEmpty == false else {
                            isAlertPresented = true
                            return
                        }
                        startReviewMode()
                    } label: {
                        Label("복습하기", systemImage: "play.fill")
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func content(_ mode: DisplayMode) -> some View {
        switch mode {
        case .inReviewing:
            WordsReviewView(words: folder.words, displayMode: $displayMode)
        case .displayingGrid:
            if folder.words.isEmpty {
                ContentUnavailableView("단어장이 비어있어요!", systemImage: "questionmark.folder", description: Text("단어를 추가해주세요."))
                    .scrollDisabled(folder.words.isEmpty)
            } else {
                wordsView(idiom)
            }
        }
    }
    
    @ViewBuilder func wordsView(_ idiom: UIUserInterfaceIdiom) -> some View {
        if idiom == .pad {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(folder.words) { word in
                        WordCard(word)
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
        } else {
            List {
                ForEach(folder.words) { word in
                    WordCard(word)
                        .padding(.vertical, 10)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
    
    private func startReviewMode() {
        withAnimation(.smooth) {
            displayMode = .inReviewing
        }
    }
}

struct FolderView_Preview: PreviewProvider {
    private static var folder: Folder = {
        let folder = Folder(name: "새 폴더")
        folder.words = [
            Word(text: "1", reading: "2", meaning: "3", in: folder),
            Word(text: "1", reading: "2", meaning: "3", in: folder),
            Word(text: "1", reading: "2", meaning: "3", in: folder),
            Word(text: "1", reading: "2", meaning: "3", in: folder),
        ]
        return folder
    }()
    
    static var previews: some View {
        FolderView(folder)
    }
}
