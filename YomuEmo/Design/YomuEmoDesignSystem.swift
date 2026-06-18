import SwiftUI

enum DS {

    // MARK: - Colors

    enum Colors {
        static let bgPrimary = Color(hex: "0a0e1a")
        static let bgSecondary = Color(hex: "111827")
        static let bgCard = Color(hex: "1a1f35")
        static let bgPaper = Color(hex: "f5f0e8")
        static let bgPaperEnd = Color(hex: "ebe4d8")

        static let textPrimary = Color(hex: "e8e2d6")
        static let textSecondary = Color(hex: "9ca3af")
        static let textPaper = Color(hex: "2c1810")

        static let accentIndigo = Color(hex: "6366f1")
        static let accentNeon = Color(hex: "818cf8")
        static let accentWarm = Color(hex: "f59e0b")
        static let accentPink = Color(hex: "ec4899")
        static let accentLavender = Color(hex: "a78bfa")

        static let borderSubtle = Color.white.opacity(0.08)

        static let paperCream = Color(hex: "FFF8F0")
        static let warmIvory = Color(hex: "FDF6EC")
        static let softPink = Color(hex: "FFD6E0")
        static let popYellow = Color(hex: "FFE66D")
        static let skyBlue = Color(hex: "A0D2DB")
        static let mintGreen = Color(hex: "B5EAD7")
        static let lavender = Color(hex: "C7CEEA")
    }

    // MARK: - Gradients

    enum Gradients {
        static let brandTitle = LinearGradient(
            colors: [Colors.accentNeon, Colors.accentPink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let progressBar = LinearGradient(
            colors: [Colors.accentIndigo, Colors.accentNeon, Colors.accentLavender],
            startPoint: .leading,
            endPoint: .trailing
        )

        static let paperCard = LinearGradient(
            colors: [Colors.bgPaper.opacity(0.95), Colors.bgPaperEnd.opacity(0.9)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let stickyNote = LinearGradient(
            colors: [Colors.popYellow.opacity(0.95), Colors.popYellow.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        static let diagnosisCard = LinearGradient(
            colors: [Colors.softPink.opacity(0.9), Colors.lavender.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Typography

    enum Fonts {
        static func serif(_ size: CGFloat) -> Font {
            .custom("HiraginoMincho-W6", size: size)
        }

        static func serifBold(_ size: CGFloat) -> Font {
            .custom("HiraginoSans-W7", size: size)
        }

        static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
            .system(size: size, weight: weight)
        }

        static func caption() -> Font {
            .system(size: 10, weight: .medium)
        }

        static func label() -> Font {
            .system(size: 11, weight: .medium)
        }

        static func small() -> Font {
            .system(size: 12)
        }
    }

    // MARK: - Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }

    // MARK: - Radius

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 14
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
    }

    // MARK: - View Modifiers

    struct GlassCard: ViewModifier {
        var cornerRadius: CGFloat = Radius.lg

        func body(content: Content) -> some View {
            content
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Colors.bgCard.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .strokeBorder(Colors.borderSubtle, lineWidth: 1)
                        )
                )
        }
    }

    struct GlassCardHighlight: ViewModifier {
        let highlightColor: Color
        var cornerRadius: CGFloat = Radius.md

        func body(content: Content) -> some View {
            content
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Colors.bgCard.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .strokeBorder(highlightColor.opacity(0.3), lineWidth: 1)
                        )
                )
        }
    }

    struct SectionHeader: ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Fonts.label())
                .foregroundColor(Colors.textSecondary)
                .textCase(.uppercase)
                .tracking(1)
        }
    }
}

// MARK: - View Extensions

extension View {
    func glassCard(cornerRadius: CGFloat = DS.Radius.lg) -> some View {
        modifier(DS.GlassCard(cornerRadius: cornerRadius))
    }

    func glassCardHighlight(_ color: Color, cornerRadius: CGFloat = DS.Radius.md) -> some View {
        modifier(DS.GlassCardHighlight(highlightColor: color, cornerRadius: cornerRadius))
    }

    func sectionHeader() -> some View {
        modifier(DS.SectionHeader())
    }
}

// MARK: - Color hex init

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }
}
