//
//  VocabularyTests.swift
//  VocabularyTests
//
//  Created by Swain Yun on 11/6/24.
//

import Testing
@testable import Vocabulary

struct VocabularyTests {
    private let meaning = "new word, new word, new word"
    private let components = "new word, new word, new word".components(separatedBy: ", ")
    
    @Test func 단어_인스턴스_생성이_잘_되어_저장_되는가() throws {
        // given
        let folder = Vocabulary.Folder(name: "new folder")
        let word = Vocabulary.Word(text: "new word", reading: "new word", meaning: "new word", in: folder)
        folder.words.append(word)
        // when
        
        
        // then
        #expect(folder.words.contains(where: { $0.id == word.id }))
    }

    @Test func 여러_의미를_가진_단어를_만들_수_있는가() throws {
        // given
        let folder = Vocabulary.Folder(name: "new folder")
        let word = Vocabulary.Word(text: "new word", reading: "new word", meaning: meaning, in: folder)
        
        // when
        
        
        // then
        let result1 = word.meaning == meaning
        let result2 = word.meanings == components
        
        #expect(result1 && result2)
    }
    
    @Test func 단어의_의미를_여러_개로_변경할_수_있는가() throws {
        // given
        let folder = Vocabulary.Folder(name: "new folder")
        let word = Vocabulary.Word(text: "new word", reading: "new word", meaning: "new word", in: folder)
        
        // when
        word.meaning = "new word, new word, new word"
        
        // then
        let result1 = word.meaning == meaning
        let result2 = word.meanings == components
        
        #expect(result1 && result2)
    }
    
    @Test func 여러_의미를_가진_단어를_저장할_때_띄어쓰기_위치와_관련없이_저장할_수_있는가() {
        // given
        let expectedMeanings: [String] = ["word", "word", "word"]
        let folder = Vocabulary.Folder(name: "new folder")
        // - "A, B, C" 형태로 주어진 경우
        let word1 = Vocabulary.Word(text: "new word", reading: "new word", meaning: "word, word, word", in: folder)
        // - "A,B,C" 형태로 주어진 경우
        let word2 = Vocabulary.Word(text: "new word", reading: "new word", meaning: "word,word,word", in: folder)
        // - "A ,B, C" 형태로 주어진 경우
        let word3 = Vocabulary.Word(text: "new word", reading: "new word", meaning: "word ,word, word", in: folder)
        // - "A ,B ,C" 형태로 주어진 경우
        let word4 = Vocabulary.Word(text: "new word", reading: "new word", meaning: "word ,word ,word", in: folder)
        // - "A , B , C" 형태로 주어진 경우
        let word5 = Vocabulary.Word(text: "new word", reading: "new word", meaning: "word , word , word", in: folder)
        // when
        
        
        // then
        #expect([word1, word2, word3, word4, word5].allSatisfy({ $0.meanings == expectedMeanings }))
    }
    
    @Test func 채점결과의_수정이_잘_이루어_지는가() throws {
        // given
        let folder = Vocabulary.Folder(name: "new folder")
        let word = Vocabulary.Word(text: "new word", reading: "new word", meaning: "new word", in: folder)
        let reviewResult = ReviewResult.build(word: word)
        
        // when
        reviewResult.word.reviewCount += 1
        
        // then
        #expect(word.reviewCount == 1)
    }
}
