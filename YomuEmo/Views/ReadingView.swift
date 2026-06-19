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
                .onTapGesture {
                    if !vm.showMenu {
                        withAnimation(.easeOut(duration: 0.25)) { vm.showMenu = true }
                    }
                }

            VStack(spacing: 0) {
                topBar
                Spacer()
                ReadingCard(
                    segment: vm.currentSegment,
                    readingMode: vm.readingMode,
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
                Spacer()
                bottomControls
            }

            // Glossary popup
            if let entry = vm.selectedGlossary {
                GlossaryPopup(entry: entry) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        vm.selectedGlossary = nil
                    }
                }
            }

            // Save toast
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

            // Reading menu overlay
            if vm.showMenu {
                readingMenuOverlay
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $vm.isCompleted) {
            CompletionView(work: work)
        }
    }

    // MARK: - Top Bar (minimal)

    private var topBar: some View {
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

    // MARK: - Bottom Controls (minimal)

    private var bottomControls: some View {
        HStack(alignment: .bottom) {
            modePill

            Spacer()

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
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.xxl)
    }

    private var modePill: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                vm.cycleReadingMode()
            }
        }) {
            Text(vm.readingMode.shortLabel)
                .font(DS.Fonts.body(11, weight: .medium))
                .foregroundColor(modeColor.opacity(0.9))
                .padding(.horizontal, DS.Spacing.md)
                .padding(.vertical, DS.Spacing.sm)
                .background(
                    Capsule()
                        .fill(DS.Colors.bgCard.opacity(0.7))
                        .overlay(
                            Capsule()
                                .strokeBorder(modeColor.opacity(0.25), lineWidth: 1)
                        )
                )
        }
    }

    private var modeColor: Color {
        switch vm.readingMode {
        case .original: return DS.Colors.accentIndigo
        case .easy: return DS.Colors.accentNeon
        case .emo: return DS.Colors.accentPink
        }
    }

    // MARK: - Advance Animation

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
            // Handle
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.15))
                .frame(width: 36, height: 4)
                .padding(.top, DS.Spacing.md)
                .padding(.bottom, DS.Spacing.lg)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: DS.Spacing.xl) {
                    menuModeSelector
                    menuFontSizeSelector
                    menuBackgroundSelector
                    menuProgress
                    menuActions
                }
                .padding(.horizontal, DS.Spacing.xl)
                .padding(.bottom, DS.Spacing.xxl)
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.55)

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

    private var menuModeSelector: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("表示モード")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            HStack(spacing: 0) {
                ForEach(ReadingMode.allCases, id: \.rawValue) { mode in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            vm.readingMode = mode
                        }
                    }) {
                        Text(mode.shortLabel)
                            .font(DS.Fonts.body(13, weight: .medium))
                            .foregroundColor(vm.readingMode == mode ? .white : DS.Colors.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, DS.Spacing.sm)
                            .background(
                                Capsule()
                                    .fill(vm.readingMode == mode ? menuModeColor(mode) : Color.clear)
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

    private func menuModeColor(_ mode: ReadingMode) -> Color {
        switch mode {
        case .original: return DS.Colors.accentIndigo
        case .easy: return DS.Colors.accentNeon
        case .emo: return DS.Colors.accentPink
        }
    }

    private var menuFontSizeSelector: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("文字サイズ")
                .font(DS.Fonts.caption())
                .foregroundColor(DS.Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)

            HStack(spacing: 0) {
                ForEach(ReadingFontSize.allCases, id: \.rawValue) { size in
                    Button(action: { vm.setFontSize(size) }) {
                        Text(size.rawValue)
                            .font(DS.Fonts.body(13, weight: .medium))
                            .foregroundColor(vm.fontSize == size ? .white : DS.Colors.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, DS.Spacing.sm)
                            .background(
                                Capsule()
                                    .fill(vm.fontSize == size ? DS.Colors.accentIndigo.opacity(0.8) : Color.clear)
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

    private var menuBackgroundSelector: some View {
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
                                            vm.backgroundStyle == bg
                                                ? DS.Colors.accentIndigo
                                                : DS.Colors.borderSubtle,
                                            lineWidth: vm.backgroundStyle == bg ? 2 : 1
                                        )
                                )
                            Text(bg.rawValue)
                                .font(DS.Fonts.caption())
                                .foregroundColor(
                                    vm.backgroundStyle == bg
                                        ? DS.Colors.textPrimary
                                        : DS.Colors.textSecondary
                                )
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

    private var menuActions: some View {
        VStack(spacing: DS.Spacing.xs) {
            menuActionRow(icon: "bookmark", label: "ことば帳") {
                vm.showMenu = false
            }
            menuActionRow(icon: "info.circle", label: "作品情報　\(work.title)") {
                vm.showMenu = false
            }
        }
    }

    private func menuActionRow(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: DS.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(DS.Colors.textSecondary)
                    .frame(width: 20)
                Text(label)
                    .font(DS.Fonts.body(14))
                    .foregroundColor(DS.Colors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundColor(DS.Colors.textSecondary.opacity(0.4))
            }
            .padding(.vertical, DS.Spacing.md)
            .padding(.horizontal, DS.Spacing.lg)
        }
        .glassCard(cornerRadius: DS.Radius.sm)
    }
}

#Preview {
    NavigationStack {
        ReadingView(work: WorksData.all[0])
    }
}
