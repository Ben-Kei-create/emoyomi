import SwiftUI

struct FavoritesView: View {
    @State private var store = StoreManager.shared
    @State private var quotes: [SavedQuote] = []

    var body: some View {
        ZStack {
            DS.Colors.bgPrimary.ignoresSafeArea()

            if quotes.isEmpty {
                emptyState
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        headerSection
                        quotesGrid
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { quotes = store.savedQuotes }
    }

    private var emptyState: some View {
        VStack(spacing: DS.Spacing.xl) {
            Text("📝")
                .font(.system(size: 56))

            Text("まだ保存した一文がありません")
                .font(DS.Fonts.body(16, weight: .medium))
                .foregroundColor(DS.Colors.textPrimary)

            Text("読書中に気になった一文を\n保存してみましょう")
                .font(DS.Fonts.body(14))
                .foregroundColor(DS.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            Text("お気に入り")
                .font(DS.Fonts.serifBold(24))
                .foregroundColor(DS.Colors.textPrimary)

            Text("\(quotes.count)件の保存した一文")
                .font(DS.Fonts.small())
                .foregroundColor(DS.Colors.textSecondary)
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.top, DS.Spacing.lg)
        .padding(.bottom, DS.Spacing.xl)
    }

    private var quotesGrid: some View {
        LazyVStack(spacing: DS.Spacing.lg) {
            ForEach(quotes) { quote in
                QuoteCard(quote: quote) {
                    withAnimation {
                        store.removeQuote(quote)
                        quotes = store.savedQuotes
                    }
                }
            }
        }
        .padding(.horizontal, DS.Spacing.xl)
        .padding(.bottom, DS.Spacing.xxxl)
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
