import SwiftUI

struct PokemonListView: View {
    @StateObject var viewModel: PokemonListViewModel
    private let accessibilityIds = PokemonListAccessibilityIdentifiers()
    private let constants = PokemonListViewConstants()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle(constants.navigationTitle)
        }
        .task {
            await viewModel.load()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .failed(let message):
            errorView(message: message)
        case .loaded(let items):
            listView(items: items)
        }
    }
    
    private var loadingView: some View {
        ProgressView(constants.loadingMessage)
            .frame(maxWidth: constants.errorFrameMaxWidth,
                   maxHeight: constants.errorFrameMaxHeight)
            .accessibilityIdentifier(accessibilityIds.loadingIndicator)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: constants.errorSpacing) {
            Text(constants.errorHeadline)
                .font(constants.errorHeadlineFont)
            Text(message)
                .font(constants.errorMessageFont)
                .foregroundStyle(constants.errorMessageStyle)
            Button(constants.retryButtonTitle) {
                Task {
                    await viewModel.load()
                }
            }
            .accessibilityIdentifier(accessibilityIds.retryButton)
        }
        .frame(maxWidth: constants.errorFrameMaxWidth,
               maxHeight: constants.errorFrameMaxHeight)
        .padding()
    }
    
    private func listView(
        items: [PokemonListItem]
    ) -> some View {
        List(items) { item in
            NavigationLink(value: item.name) {
                PokemonRowView(
                    name: item.name,
                    accessibilityIds: accessibilityIds
                )
            }
        }
        .accessibilityIdentifier(accessibilityIds.pokemonList)
        .navigationDestination(for: String.self) { name in
            PokemonDetailView(
                viewModel: PokemonDetailViewModel(name: name)
            )
        }
    }
}

struct PokemonRowView: View {
    let name: String
    let accessibilityIds: PokemonListAccessibilityIdentifiers
    private let constants = PokemonRowViewConstants()
    
    var body: some View {
        HStack {
            Text(name.capitalized)
        }
        .contentShape(Rectangle())
        .accessibilityIdentifier(accessibilityIds.pokemonRowIdentifier(for: name))
        .accessibilityLabel(name.capitalized)
        .accessibilityHint(constants.accessibilityHint)
    }
}

struct PokemonListAccessibilityIdentifiers {
    let pokemonList: String
    let loadingIndicator: String
    let retryButton: String
    let pokemonRow: String
    
    init() {
        self.pokemonList = "pokemon_list"
        self.loadingIndicator = "loading_indicator"
        self.retryButton = "retry_button"
        self.pokemonRow = "pokemon_row"
    }
    
    func pokemonRowIdentifier(for name: String) -> String {
        return "\(pokemonRow)_\(name)"
    }
}

struct PokemonListViewConstants {
    let navigationTitle: String
    let loadingMessage: String
    let errorHeadline: String
    let retryButtonTitle: String
    let errorSpacing: CGFloat
    let errorHeadlineFont: Font
    let errorMessageFont: Font
    let errorMessageStyle: Color
    let errorFrameMaxWidth: CGFloat
    let errorFrameMaxHeight: CGFloat
    
    init() {
        self.navigationTitle = "Pokémon"
        self.loadingMessage = "Loading…"
        self.errorHeadline = "Something went wrong"
        self.retryButtonTitle = "Retry"
        self.errorSpacing = 12
        self.errorHeadlineFont = .headline
        self.errorMessageFont = .footnote
        self.errorMessageStyle = .secondary
        self.errorFrameMaxWidth = .infinity
        self.errorFrameMaxHeight = .infinity
    }
}

struct PokemonRowViewConstants {
    let accessibilityHint: String
    
    init() {
        self.accessibilityHint = "Tap to view details"
    }
}
