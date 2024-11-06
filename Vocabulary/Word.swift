//
//  Item.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/6/24.
//

import Foundation
import SwiftData

@Model
final class Word {
    var text: String
    var meaning: String
    
    init(
        text: String,
        meaning: String
    ) {
        self.text = text
        self.meaning = meaning
    }
}
