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
    var meaning: String
    var folder: Folder?
    
    init(
        text: String,
        meaning: String
    ) {
        self.text = text
        self.meaning = meaning
    }
}
