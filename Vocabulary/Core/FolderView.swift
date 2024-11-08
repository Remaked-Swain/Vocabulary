//
//  FolderView.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import SwiftUI

struct FolderView: View {
    private let folder: Folder
    
    private let columns = [GridItem](repeating: .init(.flexible(), spacing: 10), count: 3)
    
    init(_ folder: Folder) {
        self.folder = folder
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(folder.words) { word in
                    WordCard(word)
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    WordEditView(folder: folder, word: nil)
                } label: {
                    Label("단어 추가", systemImage: "plus")
                }
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
