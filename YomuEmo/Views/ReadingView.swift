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
            Color(hex: "0a0e1a").ignoresSafeArea()

            VStack(spacing: 0) {
                headerBar
                Spacer()
                textCard
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
                textModeToggle
                supportCards
                Spacer()
                bottomBar
            }

            if let entry = vm.selectedGlossary {
                GlossaryPopupView(entry: entry) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        vm.selectedGlossary = nil
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $vm.isCompleted) {
            CompletionView(work: work)
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
        VStack(spacing: 12) {
            HStack {
                Button(action: { dismiss() }) {
                    Text("← 戻る")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "9ca3af"))
                }

                Spacer()

                Text(work.title)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "9ca3af"))

                Spacer()

                Text(vm.progressText)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "9ca3af").opacity(0.5))
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.05))

                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "6366f1"), Color(hex: "818cf8"), Color(hex: "a78bfa")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * vm.progress)
                        .animation(.easeInOut(duration: 0.5), value: vm.progress)
                }
            }
            .frame(height: 4)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var textCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            if vm.textMode == .original {
                glossaryText(vm.displayText, glossary: vm.currentSegment.glossary)
                    .font(.custom("HiraginoMincho-W6", size: 18))
                    .foregroundColor(Color(hex: "2c1810"))
                    .lineSpacing(8)
            } else {
                Text(vm.displayText)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(hex: "2c1810").opacity(0.9))
                    .lineSpacing(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "f5f0e8").opacity(0.95),
                            Color(hex: "ebe4d8").opacity(0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 16, y: 4)
        )
        .padding(.horizontal, 20)
        .offset(x: dragOffset)
        .opacity(1 - abs(dragOffset) / (UIScreen.main.bounds.width * 0.8))
        .id(textId)
    }

    @ViewBuilder
    private func glossaryText(_ text: String, glossary: [GlossaryEntry]) -> some View {
        if glossary.isEmpty {
            Text(text)
        } else {
            buildAnnotatedText(text, glossary: glossary)
        }
    }

    private func buildAnnotatedText(_ text: String, glossary: [GlossaryEntry]) -> some View {
        var components: [(String, GlossaryEntry?)] = []
        var remaining = text

        for entry in glossary {
            if let range = remaining.range(of: entry.word) {
                let before = String(remaining[remaining.startIndex..<range.lowerBound])
                if !before.isEmpty {
                    components.append((before, nil))
                }
                components.append((entry.word, entry))
                remaining = String(remaining[range.upperBound...])
            }
        }
        if !remaining.isEmpty {
            components.append((remaining, nil))
        }

        return HStack(spacing: 0) {
            ForEach(Array(components.enumerated()), id: \.offset) { _, component in
                if let entry = component.1 {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            vm.selectedGlossary = entry
                        }
                    }) {
                        Text(component.0)
                            .font(.custom("HiraginoMincho-W6", size: 18))
                            .foregroundColor(Color(hex: "6366f1"))
                            .underline(true, color: Color(hex: "6366f1").opacity(0.5))
                    }
                } else {
                    Text(component.0)
                }
            }
        }
    }

    private var textModeToggle: some View {
        HStack(spacing: 0) {
            ForEach([TextMode.original, TextMode.modern], id: \.rawValue) { mode in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        vm.textMode = mode
                    }
                }) {
                    Text(mode.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(vm.textMode == mode ? .white : Color(hex: "9ca3af"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(vm.textMode == mode ? Color(hex: "6366f1") : Color.clear)
                        )
                }
            }
        }
        .padding(3)
        .background(
            Capsule()
                .fill(Color(hex: "1a1f35").opacity(0.8))
                .overlay(
                    Capsule().strokeBorder(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .padding(.top, 12)
    }

    private var supportCards: some View {
        VStack(spacing: 10) {
            vibesCard
            emotionCard
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var vibesCard: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                vm.showVibes.toggle()
            }
        }) {
            VStack(alignment: .leading, spacing: 4) {
                Text("バイブス")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(hex: "ec4899"))
                    .textCase(.uppercase)
                    .tracking(1)

                if vm.showVibes {
                    Text(vm.currentSegment.vibes)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "e8e2d6"))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    Text("タップして表示")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "9ca3af").opacity(0.5))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "1a1f35").opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                vm.showVibes ? Color(hex: "ec4899").opacity(0.3) : Color.white.opacity(0.08),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var emotionCard: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                vm.showEmotions.toggle()
            }
        }) {
            VStack(alignment: .leading, spacing: 4) {
                Text("感情メーター")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(hex: "818cf8"))
                    .textCase(.uppercase)
                    .tracking(1)

                if vm.showEmotions {
                    EmotionMeterView(emotions: vm.currentSegment.emotions)
                        .padding(.top, 4)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    Text("タップして表示")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "9ca3af").opacity(0.5))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "1a1f35").opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                vm.showEmotions ? Color(hex: "818cf8").opacity(0.3) : Color.white.opacity(0.08),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private var bottomBar: some View {
        HStack {
            Text("← スワイプ or タップで次へ")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "9ca3af").opacity(0.3))
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
                            .fill(Color(hex: "6366f1"))
                            .shadow(color: Color(hex: "6366f1").opacity(0.4), radius: 12, y: 4)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
}

#Preview {
    NavigationStack {
        ReadingView(work: WorksData.all[0])
    }
}
