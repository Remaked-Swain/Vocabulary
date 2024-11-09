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
    
    @State private var displayingState: DisplayingState = .displayingGrid
    
    init(_ folder: Folder) {
        self.folder = folder
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(folder.words) { word in
                        WordCard(word)
                    }
                }
            }
            
            HStack {
                Button {
                    toggleDisplayState()
                } label: {
                    Text("복습하기")
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let newWord = Word(text: "gd", reading: "gd", meaning: "gd", in: folder)
                    folder.words.append(newWord)
                } label: {
                    Text("cnrk")
                }

                
//                NavigationLink {
//                    WordEditView(folder: folder, word: nil)
//                } label: {
//                    Label("단어 추가", systemImage: "plus")
//                }
            }
        }
        .navigationTitle(folder.name)
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
    enum DisplayingState {
        case inReviewing
        case displayingGrid
    }
    
    func toggleDisplayState() {
        if displayingState == .inReviewing {
            displayingState = .displayingGrid
        } else {
            displayingState = .inReviewing
        }
    }
}
