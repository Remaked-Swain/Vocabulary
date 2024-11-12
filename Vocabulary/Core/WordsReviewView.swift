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
    
    
    init(
        words: [Word],
        displayMode: Binding<DisplayMode>
    ) {
        let reviewResults = words.shuffled().map { ReviewResult.build(word: $0) }
        self._reviewResults = State(initialValue: reviewResults)
        self._displayMode = displayMode
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
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .containerRelativeFrame(.vertical) { length, _ in
                            length / 2
                        }
                        .disabled(true)
                        
                        
                        HStack {
                            TextField("원문 또는 의미 작성", text: $reviewAnswerText)
                                .handwritableTextFieldStyle()
                            
                            Button("제출") {
                                submitAnswer(reviewResult: reviewResults[tabViewSelectedIndex])
                            }
                            .bigButtonStyle()
                            .disabled(reviewAnswerText.isEmpty)
                            
                            Button("스킵") {
                                withAnimation(.easeInOut) {
                                    tabViewSelectedIndex += 1
                                }
                            }
                            .bigButtonStyle()
                            .disabled(reviewAnswerText.isEmpty == false)
                        }
                        .safeAreaPadding(.all)
                    }
                } else {
                    Text("모든 문제에 대한 답안을 제출하였습니다.\n채점 및 결과를 확인해주세요.")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                }
                
            }
        }
        .padding()
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    stopReviewMode()
                } label: {
                    Text("복습 모드 종료")
                }
                
                Button {
                    evaluateReview()
                } label: {
                    Text("채점 및 결과 확인")
                }
            }
        }
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
        
        withAnimation(.easeInOut) {
            tabViewSelectedIndex += 1
        }
    }
    
    private func stopReviewMode() {
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
    WordsReviewView(words: [
        Word(text: "사과", reading: "sagwa", meaning: "과일, 음식", in: Folder(name: "과일")),
        Word(text: "책", reading: "chaek", meaning: "자료, 정보, 읽을거리", in: Folder(name: "문학")),
        Word(text: "컴퓨터", reading: "keompyuteo", meaning: "기계, 전자기기", in: Folder(name: "기술")),
        Word(text: "자동차", reading: "jadongcha", meaning: "교통수단, 이동수단", in: Folder(name: "교통"))
    ], displayMode: .constant(.inReviewing))
}
