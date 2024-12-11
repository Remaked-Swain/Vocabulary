//
//  WordsReviewView.swift
//  Vocabulary
//
//  Created by Swain Yun on 11/10/24.
//

import SwiftUI

struct WordsReviewView: View {
    @State private var tabViewSelectedIndex: Int = 0
    @State private var reviewResults: [ReviewResult]
    @State private var reviewAnswerText: String = String()
    @State private var isReviewCompleted: Bool = false
    
    @Binding var displayMode: DisplayMode
    
    private let words: [Word]
    
    init(
        words: [Word],
        displayMode: Binding<DisplayMode>
    ) {
        self.words = words
        let reviewResults = words.shuffled().map { ReviewResult.build(word: $0) }
        self._reviewResults = State(initialValue: reviewResults)
        self._displayMode = displayMode
    }
    
    var body: some View {
        VStack {
            if isReviewCompleted {
                reviewResultsView()
            } else {
                VStack {
                    TabView(selection: $tabViewSelectedIndex) {
                        ForEach(0..<reviewResults.count, id: \.self) { index in
                            reviewCell(reviewResults[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .containerRelativeFrame(.vertical) { length, _ in
                        length / 2
                    }
                    .disabled(true)
                    
                    
                    HStack {
                        textField()
                        
                        Button("제출") {
                            submitAnswer(reviewResult: reviewResults[tabViewSelectedIndex])
                            
                            guard tabViewSelectedIndex < reviewResults.count else {
                                return isReviewCompleted = true
                            }
                            withAnimation(.easeInOut) {
                                tabViewSelectedIndex += 1
                            }
                        }
                        .bigButtonStyle()
                        .disabled(reviewAnswerText.isEmpty)
                        
                        Button("넘기기") {
                            guard tabViewSelectedIndex < reviewResults.count else {
                                return isReviewCompleted = true
                            }
                            
                            withAnimation(.easeInOut) {
                                tabViewSelectedIndex += 1
                            }
                        }
                        .bigButtonStyle()
                        .disabled(reviewAnswerText.isEmpty == false)
                    }
                    .safeAreaPadding(.all)
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    stopReviewing()
                } label: {
                    Label(systemIcon: .stopReviewing)
                }
                
                if isReviewCompleted {
                    Menu("재시험") {
                        Button {
                            retryReviewWithIncorrectAnswers()
                        } label: {
                            Label(systemIcon: .retryReviewWithIncorrectAnswers)
                        }
                        
                        Button {
                            retryReview()
                        } label: {
                            Label(systemIcon: .retryReview)
                        }
                        
                        Button {
                            flipAndRetryReview()
                        } label: {
                            Label(systemIcon: .flipAndRetryReview)
                        }
                    }
                } else {
                    Button {
                        evaluateReview()
                    } label: {
                        Label(systemIcon: .evaluateReview)
                    }
                    .disabled(isReviewCompleted)
                }
            }
        }
    }
    
    @ViewBuilder private func textField() -> some View {
        let reviewResult = reviewResults[tabViewSelectedIndex]
        
        switch reviewResult.showingSide {
        case .foreground:
            TextField("의미 작성", text: $reviewAnswerText)
                .handwritableTextFieldStyle()
        case .background:
            TextField("원문 작성", text: $reviewAnswerText)
                .handwritableTextFieldStyle()
        }
    }
    
    @ViewBuilder private func reviewCell(_ reviewResult: ReviewResult) -> some View {
        VStack(spacing: 10) {
            if reviewResult.showingSide == .foreground {
                Text(reviewResult.word.text)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(Constants.defaultLineLimit)
                
                Text(reviewResult.word.reading)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(Constants.defaultLineLimit)
            } else {
                Text(reviewResult.word.reading)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(Constants.defaultLineLimit)
                
                Text(reviewResult.word.meaning)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(Constants.defaultLineLimit)
            }
            
            if let explanation = reviewResult.word.explanation {
                Text(explanation)
                    .font(.headline.bold())
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .font(.largeTitle.bold())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    @ViewBuilder private func reviewResultsView() -> some View {
        VStack {
            VStack(spacing: 30) {
                Text("결과")
                    .font(.largeTitle.bold())
                    
                HStack(spacing: 30) {
                    let correctReviewResultCount = reviewResults.filter(\.isCorrect).count
                    let incorrectReviewResultCount = reviewResults.count - correctReviewResultCount
                    Text("\(correctReviewResultCount)")
                        .foregroundStyle(.green)
                    
                    Text("\(incorrectReviewResultCount)")
                        .foregroundStyle(.red)
                }
                .font(.title)
            }
            .padding()
            
            List {
                Section {
                    ForEach(reviewResults, id: \.word.id) { reviewResult in
                        reviewResultListCell(reviewResult)
                    }
                } header: {
                    HStack {
                        Text("문제")
                        
                        Spacer()
                        
                        Text("제출한 답")
                    }
                    .font(.headline)
                }
            }
            .listStyle(.plain)
        }
    }
    
    @ViewBuilder private func reviewResultListCell(_ reviewResult: ReviewResult) -> some View {
        HStack {
            SummaryWordCard(reviewResult.word)
            
            Spacer()
            
            VStack(spacing: 20) {
                Text(reviewResult.submittedAnswer ?? "-")
                    .font(.largeTitle.bold())
                    .foregroundStyle(reviewResult.isCorrect ? .green : .red)
            }
        }
    }
    
    private func retryReview() {
        tabViewSelectedIndex = .zero
        self.reviewResults = words.shuffled().map { ReviewResult.build(word: $0) }
        reviewAnswerText.removeAll()
        withAnimation(.easeInOut) {
            isReviewCompleted = false
        }
    }
    
    private func flipAndRetryReview() {
        tabViewSelectedIndex = .zero
        self.reviewResults = reviewResults.map { $0.flipShowingSide() }
        reviewAnswerText.removeAll()
        withAnimation(.easeInOut) {
            isReviewCompleted = false
        }
    }
    
    private func retryReviewWithIncorrectAnswers() {
        let incorrectReviewResults = reviewResults.filter { $0.isCorrect == false }
        tabViewSelectedIndex = .zero
        reviewResults = incorrectReviewResults
        reviewAnswerText.removeAll()
        withAnimation(.easeInOut) {
            isReviewCompleted = false
        }
    }
    
    private func submitAnswer(reviewResult: ReviewResult) {
        reviewResult.submitAnswer(reviewAnswerText)
        reviewResult.word.reviewCount += 1
        reviewAnswerText.removeAll()
    }
    
    private func stopReviewing() {
        displayMode = .displayingGrid
        isReviewCompleted = false
    }
    
    private func evaluateReview() {
        withAnimation(.smooth) {
            isReviewCompleted = true
        }
    }
}

#Preview {
    NavigationStack {
        WordsReviewView(words: [
            Word(text: "사과", reading: "sagwa", meaning: "과일, 음식", explanation: "먹는 것", in: Folder(name: "과일")),
            Word(text: "책", reading: "chaek", meaning: "자료, 정보, 읽을거리", in: Folder(name: "문학")),
            Word(text: "컴퓨터", reading: "keompyuteo", meaning: "기계, 전자기기", in: Folder(name: "기술")),
            Word(text: "자동차", reading: "jadongcha", meaning: "교통수단, 이동수단", in: Folder(name: "교통"))
        ], displayMode: .constant(.inReviewing))
    }
}
