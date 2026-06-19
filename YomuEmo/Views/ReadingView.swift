import SwiftUI

struct ReadingView: View {
    let work: Work
    @State private var vm: ReadingViewModel
    @State private var dragOffset: CGFloat = 0
    @State private var textId = UUID()
    @Environment(\.dismiss) private var dismiss

    init(work: Work) {
        self.work = work
        self._vm = State(initialValue: ReadingViewModel(work: work))
    }

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar
                Spacer()
                ReadingCard(
                    segment: vm.currentSegment,
                    readingMode: vm.readingMode,
                    onGlossaryTap: { entry in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            vm.selectedGlossary = entry
                        }
                    }
                )
                .padding(.horizontal, DS.Spacing.xl)
                .offset(x: dragOffset)
                .opacity(1 - abs(dragOffset) / (UIScreen.main.bounds.width * 0.8))
                .id(textId)
                .gesture(
                    DragGesture(minimumDistance: 30)
                        .onChanged { value in
                            if value.translation.width < 0 {
                                dragOffset = value.translation.width * 0.3
                            }
                        }
                        .onEnded { value in
                            if value.translation.width < -60 {
                                advanceWithAnimation()
                            } else {
                                withAnimation(.spring(response: 0.3)) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                HStack(spacing: DS.Spacing.md) {
                    ReadingModeToggle(readingMode: $vm.readingMode)
                    saveQuoteButton
                }
                .padding(.top, DS.Spacing.md)
                supportCards
                Spacer()
                bottomBar
            }

            if let entry = vm.selectedGlossary {
                GlossaryPopup(entry: entry) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        vm.selectedGlossary = nil
                    }
                }
            }

            if vm.showSaveToast {
                VStack {
                    HStack {
                        Spacer()
                        HStack(spacing: DS.Spacing.sm) {
                            Image(systemName: "bookmark.fill")
                                .font(.system(size: 12))
                                .foregroundColor(DS.Colors.popYellow)
                            Text("ことば帳に保存しました")
                                .font(DS.Fonts.body(12, weight: .medium))
                                .foregroundColor(DS.Colors.textPrimary)
                        }
                        .padding(.horizontal, DS.Spacing.md)
                        .padding(.vertical, DS.Spacing.xs)
                        .background(
                            Capsule()
                                .fill(DS.Colors.bgCard.opacity(0.9))
                                .overlay(
                                    Capsule()
                                        .strokeBorder(DS.Colors.popYellow.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                    .padding(.horizontal, DS.Spacing.xl)
                    .padding(.top, 60)
                    Spacer()
                }
            }

            if vm.showPoll, let poll = vm.currentPoll {
                ZStack {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { vm.showPoll = false }
                        }

                    PollCard(poll: poll)
                        .padding(.horizontal, DS.Spacing.xxl)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $vm.isCompleted) {
            CompletionView(work: work)
        }
    }

    private var saveQuoteButton: some View {
        Button(action: { vm.saveCurrentQuote() }) {
            Image(systemName: vm.quoteSaved ? "bookmark.fill" : "bookmark")
                .font(.system(size: 16))
                .foregroundColor(vm.quoteSaved ? DS.Colors.popYellow : DS.Colors.textSecondary)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(DS.Colors.bgCard.opacity(0.8))
                        .overlay(
                            Circle().strokeBorder(DS.Colors.borderSubtle, lineWidth: 1)
                        )
                )
        }
    }

    private func advanceWithAnimation() {
        withAnimation(.easeInOut(duration: 0.25)) {
            dragOffset = -UIScreen.main.bounds.width
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            vm.next()
            dragOffset = UIScreen.main.bounds.width * 0.3
            textId = UUID()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                dragOffset = 0
            }
        }
    }

    private var headerBar: some View {
        VStack(spacing: DS.Spacing.md) {
            HStack {
                Button(action: { dismiss() }) {
                    Text("← 戻る")
                        .font(DS.Fonts.body(14))
                        .foregroundColor(DS.Colors.textSecondary)
                }

                Spacer()

                Text(work.title)
                    .font(DS.Fonts.body(14))
                    .foregroundColor(DS.Colors.textSecondary)

                Spacer()

                Text(vm.progressText)
                    .font(DS.Fonts.small())
                    .foregroundColor(DS.Colors.textSecondary.opacity(0.5))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.05))

                    RoundedRectangle(cornerRadius: 2)
                        .fill(DS.Gradients.progressBar)
                        .frame(width: geo.size.width * vm.progress)
                        .animation(.easeInOut(duration: 0.5), value: vm.progress)
                }
            }
            .frame(height: 4)
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.top, DS.Spacing.md)
    }

    private var supportCards: some View {
        VStack(spacing: 10) {
            vibesCard
            emotionCard
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.top, DS.Spacing.md)
    }

    private var vibesCard: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                vm.showVibes.toggle()
            }
        }) {
            VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                Text("バイブス")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.accentPink)
                    .textCase(.uppercase)
                    .tracking(1)

                if vm.showVibes {
                    Text(vm.currentSegment.vibesSummary)
                        .font(DS.Fonts.body(14))
                        .foregroundColor(DS.Colors.textPrimary)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    Text("タップして表示")
                        .font(DS.Fonts.small())
                        .foregroundColor(DS.Colors.textSecondary.opacity(0.5))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DS.Spacing.lg)
            .glassCardHighlight(vm.showVibes ? DS.Colors.accentPink : .clear)
        }
        .buttonStyle(.plain)
    }

    private var emotionCard: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                vm.showEmotions.toggle()
            }
        }) {
            VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                Text("感情メーター")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.accentNeon)
                    .textCase(.uppercase)
                    .tracking(1)

                if vm.showEmotions {
                    EmotionMeter(emotionScores: vm.currentSegment.emotionScores)
                        .padding(.top, DS.Spacing.xs)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    Text("タップして表示")
                        .font(DS.Fonts.small())
                        .foregroundColor(DS.Colors.textSecondary.opacity(0.5))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DS.Spacing.lg)
            .glassCardHighlight(vm.showEmotions ? DS.Colors.accentNeon : .clear)
        }
        .buttonStyle(.plain)
    }

    private var bottomBar: some View {
        HStack {
            Text("← スワイプ or タップで次へ")
                .font(DS.Fonts.body(11))
                .foregroundColor(DS.Colors.textSecondary.opacity(0.3))
            Spacer()
            Button(action: {
                advanceWithAnimation()
            }) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 64, height: 64)
                    .background(
                        Circle()
                            .fill(DS.Colors.accentIndigo)
                            .shadow(color: DS.Colors.accentIndigo.opacity(0.4), radius: 12, y: 4)
                    )
            }
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.xxl)
    }
}

#Preview {
    NavigationStack {
        ReadingView(work: WorksData.all[0])
    }
}
