//
//  Folder.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import Foundation
import SwiftData

/**
 그룹화한 단어장
 */
@Model
final class Folder {
    var name: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade, inverse: \Word.folder) var words: [Word] = []
    
    init(
        name: String,
        createdAt: Date = .now
    ) {
        self.name = name
        self.createdAt = createdAt
    }
}
