import SwiftUI

struct ReadingView: View {
    let work: Work
    @State private var vm: ReadingViewModel
    @State private var dragOffset: CGFloat = 0
    @State private var textId = UUID()
    @State private var isAdvancing = false
    @Environment(\.dismiss) private var dismiss

    init(work: Work) {
        self.work = work
        self._vm = State(initialValue: ReadingViewModel(work: work))
    }

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()
                .onTapGesture { handleBackgroundTap() }

            switch vm.readingMode {
            case .lyric: lyricLayout
            case .cinema: cinemaLayout
            case .focus: focusLayout
            }

            if let entry = vm.selectedGlossary {
                GlossaryPopup(entry: entry, glossaryMode: vm.glossaryMode) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        vm.selectedGlossary = nil
                    }
                }
            }

            if vm.showSaveToast {
                saveToast
            }

            if vm.showMenu {
                readingMenuOverlay
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $vm.isCompleted) {
            CompletionView(work: work)
        }
        .onAppear {
            vm.restartAutoPlayIfNeeded()
            if vm.readingMode == .focus { vm.resetFocusHideTimer() }
        }
        .onDisappear {
            vm.stopAutoPlay()
        }
    }

    private func handleBackgroundTap() {
        if vm.readingMode == .focus {
            vm.showFocusControls()
        } else {
            withAnimation(.easeOut(duration: 0.25)) { vm.showMenu = true }
        }
    }

    // MARK: - Lyric Mode

    private var lyricLayout: some View {
        VStack(spacing: 0) {
            minimalTopBar
            Spacer()
            lyricContent
            Spacer()
            HStack(alignment: .bottom) {
                modePill
                Spacer()
                nextButton
            }
            .padding(.horizontal, DS.Spacing.xl)
            .padding(.bottom, DS.Spacing.xxl)
        }
    }

    private var lyricContent: some View {
        VStack(spacing: DS.Spacing.xxl) {
            if let prev = vm.previousSegment {
                Text(vm.displayText(for: prev))
                    .font(DS.Fonts.serif(14 * vm.fontSize.scale))
                    .foregroundColor(DS.Colors.textPrimary.opacity(0.25))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DS.Spacing.xxxl)
                    .transition(.opacity)
            }

            ReadingCard(
                text: vm.displayText(for: vm.currentSegment),
                glossaryEntries: vm.currentSegment.glossaryEntries,
                fontScale: vm.fontSize.scale,
                backgroundStyle: vm.backgroundStyle,
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
            .gesture(swipeGesture)

            if let next = vm.nextSegment {
                Text(vm.displayText(for: next))
                    .font(DS.Fonts.serif(14 * vm.fontSize.scale))
                    .foregroundColor(DS.Colors.textPrimary.opacity(0.15))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DS.Spacing.xxxl)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: vm.currentIndex)
    }

    // MARK: - Cinema Mode

    private var cinemaLayout: some View {
        VStack(spacing: 0) {
            minimalTopBar
            Spacer()
            cinemaContent
            Spacer()
            HStack(alignment: .bottom) {
                modePill
                Spacer()
                cinemaPauseButton
                    .padding(.trailing, DS.Spacing.md)
                nextButton
            }
            .padding(.horizontal, DS.Spacing.xl)
            .padding(.bottom, DS.Spacing.xxl)
        }
    }

    private var cinemaContent: some View {
        VStack(spacing: DS.Spacing.xl) {
            ForEach(visiblePastIndices, id: \.self) { i in
                Text(vm.displayText(for: work.segments[i]))
                    .font(DS.Fonts.serif(15 * vm.fontSize.scale))
                    .foregroundColor(DS.Colors.textPrimary.opacity(pastOpacity(for: i)))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DS.Spacing.xxl)
            }

            glossaryTextView(vm.currentSegment)
                .font(DS.Fonts.serif(18 * vm.fontSize.scale))
                .foregroundColor(DS.Colors.textPrimary.opacity(0.9))
                .lineSpacing(8)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DS.Spacing.xxl)
                .id(textId)
        }
        .animation(.easeInOut(duration: 0.6), value: vm.currentIndex)
        .gesture(swipeGesture)
    }

    private var visiblePastIndices: [Int] {
        let start = max(0, vm.currentIndex - 3)
        return Array(start..<vm.currentIndex)
    }

    private func pastOpacity(for index: Int) -> Double {
        let distance = vm.currentIndex - index
        return max(0.08, 0.3 - Double(distance) * 0.08)
    }

    private var cinemaPauseButton: some View {
        Button(action: { vm.toggleCinemaPause() }) {
            Image(systemName: vm.cinemaPaused ? "play.fill" : "pause.fill")
                .font(.system(size: 14))
                .foregroundColor(DS.Colors.textSecondary)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(DS.Colors.bgCard.opacity(0.7))
                        .overlay(Circle().strokeBorder(DS.Colors.borderSubtle, lineWidth: 1))
                )
        }
    }

    // MARK: - Focus Mode

    private var focusLayout: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { vm.showFocusControls() }

            VStack {
                Spacer()
                glossaryTextView(vm.currentSegment)
                    .font(DS.Fonts.serif(20 * vm.fontSize.scale))
                    .foregroundColor(DS.Colors.textPrimary.opacity(0.85))
                    .lineSpacing(10)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DS.Spacing.xxl)
                    .id(textId)
                    .gesture(swipeGesture)
                Spacer()
            }

            if vm.focusControlsVisible {
                VStack {
                    minimalTopBar
                    Spacer()
                    HStack(alignment: .bottom) {
                        modePill
                        Spacer()
                        nextButton
                    }
                    .padding(.horizontal, DS.Spacing.xl)
                    .padding(.bottom, DS.Spacing.xxl)
                }
                .transition(.opacity)
            }
        }
    }

    // MARK: - Shared Components

    private var minimalTopBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(DS.Colors.textSecondary.opacity(0.5))
                    .frame(width: 36, height: 36)
            }
            Spacer()
            Button(action: { vm.saveCurrentQuote() }) {
                Image(systemName: vm.quoteSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 16))
                    .foregroundColor(vm.quoteSaved ? DS.Colors.popYellow : DS.Colors.textSecondary.opacity(0.5))
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, DS.Spacing.lg)
        .padding(.top, DS.Spacing.sm)
    }

    @ViewBuilder
    private func glossaryTextView(_ segment: TextSegment) -> some View {
        let text = vm.displayText(for: segment)
        let glossary = segment.glossaryEntries
        if glossary.isEmpty {
            Text(text)
        } else {
            buildAnnotatedText(text, glossary: glossary)
        }
    }

    private func buildAnnotatedText(_ text: String, glossary: [GlossaryEntry]) -> some View {
        var attrStr = AttributedString(text)
        for (index, entry) in glossary.enumerated() {
            if let range = attrStr.range(of: entry.word) {
                attrStr[range].link = URL(string: "glossary://word/\(index)")
                attrStr[range].underlineStyle = Text.LineStyle(
                    pattern: .solid, color: DS.Colors.accentIndigo.opacity(0.5)
                )
            }
        }
        return Text(attrStr)
            .tint(DS.Colors.accentIndigo)
            .environment(\.openURL, OpenURLAction { url in
                if url.scheme == "glossary",
                   let index = Int(url.lastPathComponent),
                   index < glossary.count {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        vm.selectedGlossary = glossary[index]
                    }
                }
                return .handled
            })
    }

    private var modePill: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.25)) { vm.showMenu = true }
        }) {
            HStack(spacing: DS.Spacing.xs) {
                Image(systemName: vm.readingMode.icon)
                    .font(.system(size: 10))
                Text(vm.readingMode.rawValue)
                    .font(DS.Fonts.body(11, weight: .medium))
            }
            .foregroundColor(DS.Colors.textSecondary.opacity(0.7))
            .padding(.horizontal, DS.Spacing.md)
            .padding(.vertical, DS.Spacing.sm)
            .background(
                Capsule()
                    .fill(DS.Colors.bgCard.opacity(0.6))
                    .overlay(Capsule().strokeBorder(DS.Colors.borderSubtle, lineWidth: 1))
            )
        }
    }

    private var nextButton: some View {
        Button(action: { advanceWithAnimation() }) {
            Image(systemName: "arrow.right")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 52, height: 52)
                .background(
                    Circle()
                        .fill(DS.Colors.accentIndigo)
                        .shadow(color: DS.Colors.accentIndigo.opacity(0.3), radius: 8, y: 3)
                )
        }
    }

    private var saveToast: some View {
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
                        .overlay(Capsule().strokeBorder(DS.Colors.popYellow.opacity(0.2), lineWidth: 1))
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            .padding(.horizontal, DS.Spacing.xl)
            .padding(.top, 60)
            Spacer()
        }
    }

    // MARK: - Gestures

    private var swipeGesture: some Gesture {
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
    }

    private func advanceWithAnimation() {
        guard !isAdvancing else { return }
        isAdvancing = true
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
            isAdvancing = false
        }
    }

    // MARK: - Reading Menu

    private var readingMenuOverlay: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.2)) { vm.showMenu = false }
                }

            readingMenuSheet
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private var readingMenuSheet: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.15))
                .frame(width: 36, height: 4)
                .padding(.top, DS.Spacing.md)
                .padding(.bottom, DS.Spacing.lg)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DS.Spacing.xl) {
                    menuReadingMode
                    menuTextMode
                    menuGlossaryMode
                    menuAutoPlay
                    menuFontSize
                    menuBackground
                    menuProgress
                }
                .padding(.horizontal, DS.Spacing.xl)
                .padding(.bottom, DS.Spacing.xxl)
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.6)

            Button(action: {
                withAnimation(.easeIn(duration: 0.2)) { vm.showMenu = false }
            }) {
                Text("閉じる")
                    .font(DS.Fonts.body(14, weight: .medium))
                    .foregroundColor(DS.Colors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .padding(.bottom, DS.Spacing.lg)
        }
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.xl)
                .fill(DS.Colors.bgSecondary.opacity(0.97))
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.xl)
                        .strokeBorder(DS.Colors.borderSubtle, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.4), radius: 20, y: -4)
        )
        .ignoresSafeArea(.container, edges: .bottom)
    }

    // MARK: - Menu Sections

    private var menuReadingMode: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("読書モード")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            HStack(spacing: DS.Spacing.sm) {
                ForEach(ReadingMode.allCases, id: \.rawValue) { mode in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            vm.setReadingMode(mode)
                        }
                    }) {
                        VStack(spacing: DS.Spacing.xs) {
                            Image(systemName: mode.icon)
                                .font(.system(size: 18))
                            Text(mode.rawValue)
                                .font(DS.Fonts.body(11, weight: .medium))
                        }
                        .foregroundColor(vm.readingMode == mode ? .white : DS.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DS.Spacing.md)
                        .background(
                            RoundedRectangle(cornerRadius: DS.Radius.sm)
                                .fill(vm.readingMode == mode ? DS.Colors.accentIndigo : DS.Colors.bgCard.opacity(0.5))
                        )
                    }
                }
            }
        }
    }

    private var menuTextMode: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("テキスト")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            segmentedPicker(
                items: TextMode.allCases,
                selected: vm.textMode,
                label: \.rawValue,
                onSelect: { vm.setTextMode($0) }
            )
        }
    }

    private var menuGlossaryMode: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("辞書モード")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            segmentedPicker(
                items: GlossaryMode.allCases,
                selected: vm.glossaryMode,
                label: \.rawValue,
                onSelect: { vm.setGlossaryMode($0) }
            )
        }
    }

    private var menuAutoPlay: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("自動再生")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DS.Spacing.sm) {
                    ForEach(AutoPlaySpeed.allCases, id: \.rawValue) { speed in
                        Button(action: { vm.setAutoPlay(speed) }) {
                            Text(speed.rawValue)
                                .font(DS.Fonts.body(11, weight: .medium))
                                .foregroundColor(vm.autoPlaySpeed == speed ? .white : DS.Colors.textSecondary)
                                .padding(.horizontal, DS.Spacing.md)
                                .padding(.vertical, DS.Spacing.sm)
                                .background(
                                    Capsule()
                                        .fill(vm.autoPlaySpeed == speed ? DS.Colors.accentIndigo.opacity(0.8) : DS.Colors.bgCard.opacity(0.5))
                                )
                        }
                    }
                }
            }
        }
    }

    private var menuFontSize: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("文字サイズ")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            segmentedPicker(
                items: ReadingFontSize.allCases,
                selected: vm.fontSize,
                label: \.rawValue,
                onSelect: { vm.setFontSize($0) }
            )
        }
    }

    private var menuBackground: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("背景")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            HStack(spacing: DS.Spacing.md) {
                ForEach(ReadingBackground.allCases, id: \.rawValue) { bg in
                    Button(action: { vm.setBackground(bg) }) {
                        VStack(spacing: DS.Spacing.xs) {
                            RoundedRectangle(cornerRadius: DS.Radius.sm)
                                .fill(bgPreviewColor(bg))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    RoundedRectangle(cornerRadius: DS.Radius.sm)
                                        .strokeBorder(
                                            vm.backgroundStyle == bg ? DS.Colors.accentIndigo : DS.Colors.borderSubtle,
                                            lineWidth: vm.backgroundStyle == bg ? 2 : 1
                                        )
                                )
                            Text(bg.rawValue)
                                .font(DS.Fonts.caption())
                                .foregroundColor(vm.backgroundStyle == bg ? DS.Colors.textPrimary : DS.Colors.textSecondary)
                        }
                    }
                }
                Spacer()
            }
        }
    }

    private func bgPreviewColor(_ bg: ReadingBackground) -> Color {
        switch bg {
        case .paper: return DS.Colors.bgPaper
        case .cream: return DS.Colors.warmIvory
        case .white: return .white
        }
    }

    private var menuProgress: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("進捗")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            HStack(spacing: DS.Spacing.lg) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.progressPercent)
                        .font(DS.Fonts.serifBold(20))
                        .foregroundColor(DS.Colors.textPrimary)
                    Text(vm.progressText)
                        .font(DS.Fonts.caption())
                        .foregroundColor(DS.Colors.textSecondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.06))
                        RoundedRectangle(cornerRadius: 3)
                            .fill(DS.Gradients.progressBar)
                            .frame(width: geo.size.width * vm.progress)
                    }
                }
                .frame(height: 6)

                Text("残り約\(vm.estimatedMinutes)分")
                    .font(DS.Fonts.caption())
                    .foregroundColor(DS.Colors.textSecondary)
            }
            .padding(DS.Spacing.lg)
            .glassCard(cornerRadius: DS.Radius.sm)
        }
    }

    // MARK: - Menu Helpers

    private func segmentedPicker<T: Equatable>(
        items: [T],
        selected: T,
        label: KeyPath<T, String>,
        onSelect: @escaping (T) -> Void
    ) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                Button(action: { onSelect(item) }) {
                    Text(item[keyPath: label])
                        .font(DS.Fonts.body(13, weight: .medium))
                        .foregroundColor(selected == item ? .white : DS.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DS.Spacing.sm)
                        .background(
                            Capsule()
                                .fill(selected == item ? DS.Colors.accentIndigo.opacity(0.8) : Color.clear)
                        )
                }
            }
        }
        .padding(3)
        .background(
            Capsule()
                .fill(DS.Colors.bgCard.opacity(0.8))
                .overlay(Capsule().strokeBorder(DS.Colors.borderSubtle, lineWidth: 1))
        )
    }

}

#Preview {
    NavigationStack {
        ReadingView(work: WorksData.all[0])
    }
}
