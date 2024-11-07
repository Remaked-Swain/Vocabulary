//
//  MainView.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    private struct Namespace {
        static let defaultFolderName: String = "새 폴더"
    }
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Folder.createdAt) private var folders: [Folder]
    
    @State private var isSheetPresented: Bool = false
    @State private var newFolderName: String = Namespace.defaultFolderName
    
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
                    Button(action: presentSheet) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .alert("새로운 폴더 만들기", isPresented: $isSheetPresented) {
                VStack {
                    TextField("새로운 폴더 이름", text: $newFolderName, prompt: Text("새 폴더"))
                    
                    Button {
                        createFolder()
                    } label: {
                        Text("확인")
                    }
                }
            } message: {
                Text("새로운 폴더를 생성합니다.")
            }
        }
    }
    
    private func presentSheet() {
        isSheetPresented.toggle()
    }
    
    private func createFolder() {
        withAnimation {
            let newFolder = Folder(name: newFolderName.isEmpty ? "새 폴더" : newFolderName)
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
        .modelContainer(for: [Word.self, Folder.self], inMemory: true)
}
