//
//  MainView.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Folder.createdAt) private var folders: [Folder]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(folders) { folder in
                    NavigationLink {
                        FolderView(folder)
                    } label: {
                        Text(folder.name)
                    }
                }
                .onDelete(perform: deleteFolder)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: createFolder) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func createFolder() {
        withAnimation {
            let newFolder = Folder(name: "새로운 폴더")
            modelContext.insert(newFolder)
        }
    }

    private func deleteFolder(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(folders[index])
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: Word.self, inMemory: true)
}

struct FolderView: View {
    private let folder: Folder
    
    init(_ folder: Folder) {
        self.folder = folder
    }
    
    var body: some View {
        List {
            ForEach(folder.words) { word in
                Text(word.text)
            }
            .onDelete(perform: deleteWord)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: createWord) {
                    Label("단어 추가", systemImage: "plus.app")
                }
            }
        }
    }
    
    private func createWord() {
        let newWord = Word(text: "new", meaning: "new")
        folder.words.append(newWord)
    }
    
    private func deleteWord(offsets: IndexSet) {
        folder.words.remove(atOffsets: offsets)
    }
}
