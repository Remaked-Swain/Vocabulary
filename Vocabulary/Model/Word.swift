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
    private(set) var meanings: [String]
    var explanation: String?
    var meaning: String {
        get { meanings.joined(separator: ", ") }
        set { meanings = newValue.components(separatedBy: ", ") }
    }
    var folder: Folder
    var reviewCount: Int = 0
    var isReviewed: Bool { reviewCount > 3 }
    
    init(
        text: String,
        reading: String,
        meaning: String,
        explanation: String? = nil,
        in folder: Folder
    ) {
        self.text = text
        self.reading = reading
        self.meanings = meaning.components(separatedBy: ", ")
        self.explanation = explanation
        self.folder = folder
    }
}
