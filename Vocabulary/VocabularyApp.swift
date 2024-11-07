//
//  VocabularyApp.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import SwiftUI
import SwiftData

@main
struct VocabularyApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([
            Word.self,
            Folder.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(modelContainer)
    }
}
