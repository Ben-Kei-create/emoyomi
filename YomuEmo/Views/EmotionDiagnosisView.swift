import SwiftUI

struct EmotionDiagnosisView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var answers: [Int] = []
    @State private var result: EmotionDiagnosisResult?
    @State private var showResult = false

    private let questions: [(question: String, options: [String])] = [
        (
            "今の気分は？",
            ["疲れた", "自信がない", "恋をしている", "人生迷子", "前向き", "なんとなく不安"]
        ),
        (
            "今日はどんな物語を読みたい？",
            ["共感したい", "元気をもらいたい", "考えさせられたい", "切なくなりたい"]
        ),
        (
            "今の感情に近いものは？",
            ["孤独", "不安", "嫉妬", "恋愛", "希望", "青春"]
        ),
    ]

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            if showResult, let result {
                resultView(result)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                questionView
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .navigationBarHidden(true)
    }

    private var questionView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    if currentStep > 0 {
                        withAnimation { currentStep -= 1; answers.removeLast() }
                    } else {
                        dismiss()
                    }
                }) {
                    Text("← 戻る")
                        .font(DS.Fonts.body(14))
                        .foregroundColor(DS.Colors.textSecondary)
                }
                Spacer()
                Text("\(currentStep + 1) / \(questions.count)")
                    .font(DS.Fonts.small())
                    .foregroundColor(DS.Colors.textSecondary.opacity(0.5))
            }
            .padding(.horizontal, DS.Spacing.xl)
            .padding(.top, DS.Spacing.md)

            progressDots
                .padding(.top, DS.Spacing.xxl)

            Spacer()

            VStack(spacing: DS.Spacing.xxxl) {
                Text(questions[currentStep].question)
                    .font(DS.Fonts.serifBold(26))
                    .foregroundColor(DS.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .id(currentStep)

                optionsGrid
                    .id(currentStep)
            }
            .padding(.horizontal, DS.Spacing.xl)

            Spacer()
            Spacer()
        }
    }

    private var progressDots: some View {
        HStack(spacing: DS.Spacing.sm) {
            ForEach(0..<questions.count, id: \.self) { i in
                Circle()
                    .fill(i <= currentStep ? DS.Colors.accentPink : DS.Colors.bgCard)
                    .frame(width: i == currentStep ? 12 : 8, height: i == currentStep ? 12 : 8)
                    .animation(.spring(response: 0.3), value: currentStep)
            }
        }
    }

    private var optionsGrid: some View {
        let options = questions[currentStep].options
        let columns = options.count <= 4
            ? [GridItem(.flexible(), spacing: DS.Spacing.md), GridItem(.flexible(), spacing: DS.Spacing.md)]
            : [GridItem(.flexible(), spacing: DS.Spacing.md), GridItem(.flexible(), spacing: DS.Spacing.md), GridItem(.flexible(), spacing: DS.Spacing.md)]

        return LazyVGrid(columns: columns, spacing: DS.Spacing.md) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                Button {
                    selectOption(index)
                } label: {
                    Text(option)
                        .font(DS.Fonts.body(15, weight: .medium))
                        .foregroundColor(DS.Colors.textPaper)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: DS.Radius.md)
                                .fill(optionColor(for: index))
                                .shadow(color: optionColor(for: index).opacity(0.3), radius: 6, y: 2)
                        )
                }
            }
        }
    }

    private func optionColor(for index: Int) -> Color {
        let colors = [DS.Colors.softPink, DS.Colors.lavender, DS.Colors.skyBlue, DS.Colors.mintGreen, DS.Colors.popYellow, DS.Colors.warmIvory]
        return colors[index % colors.count]
    }

    private func selectOption(_ index: Int) {
        answers.append(index)

        if currentStep < questions.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep += 1
            }
        } else {
            generateResult()
        }
    }

    private func generateResult() {
        let emotionMap: [String: EmotionTag] = [
            "孤独": .孤独, "不安": .不安, "嫉妬": .嫉妬,
            "恋愛": .恋愛, "希望": .希望, "青春": .青春,
        ]

        let selectedEmotion = questions[2].options[answers.last ?? 0]
        let primaryTag = emotionMap[selectedEmotion] ?? .孤独

        let moodIndex = answers[0]
        let storyType = answers[1]

        let matchedWork: Work
        let reason: String

        switch (primaryTag, moodIndex, storyType) {
        case (.孤独, _, _), (_, 0, 0), (_, 1, 0):
            matchedWork = WorksData.find(by: "ningen-shikkaku") ?? WorksData.all[0]
            reason = "周りに合わせて生きる苦しさに共感できる作品です。"
        case (.希望, _, _), (_, 4, 1), (_, _, 1):
            matchedWork = WorksData.find(by: "hashire-melos") ?? WorksData.all[2]
            reason = "信じることの力を、全力で感じられる物語です。"
        case (.不安, _, _), (_, 5, _), (_, _, 2):
            matchedWork = WorksData.find(by: "rashomon") ?? WorksData.all[1]
            reason = "追い詰められた時の人間の本質を、一緒に考えられる作品です。"
        case (.恋愛, _, _), (_, 2, _):
            matchedWork = WorksData.find(by: "kokoro") ?? WorksData.all[3]
            reason = "恋と罪悪感の間で揺れる感情に、胸が締め付けられます。"
        case (.青春, _, _), (_, 3, 3):
            matchedWork = WorksData.find(by: "gingatetsudo") ?? WorksData.all[4]
            reason = "大切な人との時間の尊さが、銀河の旅を通して感じられます。"
        default:
            matchedWork = WorksData.all[0]
            reason = "今のあなたの気持ちに寄り添ってくれる作品です。"
        }

        var emotions: [EmotionTag: Int] = [:]
        for tag in matchedWork.tags {
            let maxScore = matchedWork.segments.compactMap { $0.emotionScores[tag] }.max() ?? 50
            emotions[tag] = maxScore
        }

        result = EmotionDiagnosisResult(
            work: matchedWork,
            matchedEmotions: emotions,
            reason: reason
        )

        withAnimation(.easeInOut(duration: 0.5)) {
            showResult = true
        }
    }

    private func resultView(_ result: EmotionDiagnosisResult) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer().frame(height: 60)

                Text("✨")
                    .font(.system(size: 48))
                    .padding(.bottom, DS.Spacing.lg)

                Text("おすすめ作品")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.accentPink)
                    .textCase(.uppercase)
                    .tracking(1)
                    .padding(.bottom, DS.Spacing.xl)

                VStack(spacing: DS.Spacing.lg) {
                    Text(result.work.coverEmoji)
                        .font(.system(size: 56))

                    Text(result.work.title)
                        .font(DS.Fonts.serifBold(28))
                        .foregroundColor(DS.Colors.textPrimary)

                    Text(result.work.authorName)
                        .font(DS.Fonts.body(16))
                        .foregroundColor(DS.Colors.textSecondary)
                }
                .padding(.bottom, DS.Spacing.xxxl)

                VStack(alignment: .leading, spacing: DS.Spacing.lg) {
                    Text("あなたの感情")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.accentNeon)
                        .textCase(.uppercase)
                        .tracking(1)

                    EmotionMeter(emotionScores: result.matchedEmotions)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DS.Spacing.xl)
                .glassCard()
                .padding(.horizontal, DS.Spacing.xl)
                .padding(.bottom, DS.Spacing.lg)

                VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                    Text("おすすめ理由")
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.accentPink)
                        .textCase(.uppercase)
                        .tracking(1)

                    Text("「\(result.reason)」")
                        .font(DS.Fonts.body(15))
                        .foregroundColor(DS.Colors.textPrimary)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DS.Spacing.xl)
                .glassCard()
                .padding(.horizontal, DS.Spacing.xl)
                .padding(.bottom, DS.Spacing.xxxl)

                NavigationLink(destination: ReadingView(work: result.work)) {
                    Text("この作品を読む")
                        .font(DS.Fonts.body(18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            Capsule()
                                .fill(DS.Colors.accentIndigo)
                                .shadow(color: DS.Colors.accentIndigo.opacity(0.4), radius: 16, y: 4)
                        )
                }
                .padding(.horizontal, DS.Spacing.xl)

                Button(action: {
                    withAnimation {
                        showResult = false
                        currentStep = 0
                        answers = []
                        self.result = nil
                    }
                }) {
                    Text("もう一度診断する")
                        .font(DS.Fonts.body(14))
                        .foregroundColor(DS.Colors.textSecondary)
                }
                .padding(.top, DS.Spacing.lg)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmotionDiagnosisView()
    }
}
