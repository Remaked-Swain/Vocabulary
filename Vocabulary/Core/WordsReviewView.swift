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
    
    @Binding var isReviewCompleted: Bool
    
    init(words: [Word], isReviewCompleted: Binding<Bool>) {
        let reviewResults = words.shuffled().map { ReviewResult.build(word: $0) }
        self._reviewResults = State(initialValue: reviewResults)
        self._isReviewCompleted = isReviewCompleted
    }
    
    var body: some View {
        VStack {
            if isReviewCompleted {
                reviewResultsView()
            } else {
                if tabViewSelectedIndex < reviewResults.count {
                    VStack {
                        TabView(selection: $tabViewSelectedIndex) {
                            ForEach(0..<reviewResults.count, id: \.self) { index in
                                reviewCell(reviewResults[index])
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page)
                        .containerRelativeFrame(.vertical) { length, _ in
                            length / 2
                        }
                        
                        HStack {
                            TextField("원문 또는 의미 작성", text: $reviewAnswerText)
                                .handwritableTextFieldStyle()
                            
                            Button("제출") {
                                submitAnswer(reviewResult: reviewResults[tabViewSelectedIndex])
                            }
                            .bigButtonStyle()
                            .disabled(reviewAnswerText.isEmpty)
                        }
                    }
                } else {
                    Text("모든 문제에 대한 답안을 제출하였습니다.\n채점 및 결과를 확인해주세요.")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder private func reviewCell(_ reviewResult: ReviewResult) -> some View {
        VStack(spacing: 10) {
            if reviewResult.showingSide == .foreground {
                Text(reviewResult.word.text)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Text(reviewResult.word.reading)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text(reviewResult.word.reading)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Text(reviewResult.word.meaning)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .font(.largeTitle.bold())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    @ViewBuilder private func reviewResultsView() -> some View {
        VStack {
            Text("결과")
                .font(.title)
                .padding()
            
            List {
                Section {
                    ForEach(reviewResults, id: \.word.id) { reviewResult in
                        reviewResultListCell(reviewResult)
                            .swipeActions {
                                Button {
                                    reviewResult.adjustCorrection(to: .correct)
                                } label: {
                                    Text("정답처리")
                                }
                                .tint(.green)
                                
                                Button {
                                    reviewResult.adjustCorrection(to: .incorrect)
                                } label: {
                                    Text("오답처리")
                                }
                                .tint(.red)
                            }
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
            VStack(spacing: 20) {
                Text(reviewResult.word.text)
                    .font(.largeTitle.bold())
                
                HStack(spacing: 20) {
                    Text(reviewResult.word.reading)
                    Text(reviewResult.word.meaning)
                }
                .font(.title2.bold())
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(spacing: 20) {
                Text(reviewResult.submittedAnswer)
                    .font(.largeTitle.bold())
                    .foregroundStyle(reviewResult.isCorrect ? .green : .red)
            }
        }
    }
    
    private func submitAnswer(reviewResult: ReviewResult) {
        reviewResult.submitAnswer(reviewAnswerText)
        reviewResult.word.reviewCount += 1
        reviewAnswerText.removeAll()
        
        withAnimation(.bouncy) {
            tabViewSelectedIndex += 1
        }
    }
}
