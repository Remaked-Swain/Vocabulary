//
//  Item.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import Foundation
import SwiftData

@Model
class Word {
    var text: String
    var reading: String
    var meanings: [String]
    var meaning: String { meanings.joined(separator: ", ") }
    var folder: Folder
    var reviewCount: Int = 0
    var isReviewed: Bool { reviewCount > 3 }
    
    init(
        text: String,
        reading: String,
        meaning: String,
        in folder: Folder
    ) {
        self.text = text
        self.reading = reading
        self.meanings = meaning.components(separatedBy: ",")
        self.folder = folder
    }
}
