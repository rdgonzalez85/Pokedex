import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject var viewModel: PokemonDetailViewModel
    private let accessibilityIds = PokemonDetailAccessibilityIdentifiers()
    private let constants = PokemonDetailViewConstants()
    
    var body: some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.load()
            }
            .padding()
    }
    
    private var title: String {
        switch viewModel.state {
            case .loaded(let detail):
                return detail.name.capitalized
            default:
                return constants.defaultNavigationTitle
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView(constants.loadingMessage)
                .frame(maxWidth: constants.errorFrameMaxWidth, maxHeight: constants.errorFrameMaxHeight, alignment: .center)
                .accessibilityIdentifier(accessibilityIds.loadingIndicator)
        case .failed(let message):
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
            .frame(maxWidth: constants.errorFrameMaxWidth, maxHeight: constants.errorFrameMaxHeight)
        case .loaded(let pokemon):
            ScrollView {
                VStack(spacing: constants.contentSpacing) {
                    AsyncImage(url: pokemon.imageURL) { image in
                        image
                            .resizable()
                            .shadow(radius: constants.imageShadowRadius)
                    } placeholder: {
                        Rectangle()
                            .clipped()
                            .foregroundColor(constants.imageBackgroundColor)
                    }
                    .frame(width: constants.imageWidth,
                           height: constants.imageHeight)
                    .accessibilityElement(children: .ignore)
                    .accessibilityIdentifier(accessibilityIds.pokemonImage)
                    .accessibilityLabel("Image of \(pokemon.name.capitalized)")
                    .accessibilityAddTraits(.isImage)
                    
                    VStack(alignment: constants.detailsAlignment,
                           spacing: constants.detailsSpacing) {
                        Text(pokemon.name.capitalized)
                            .font(constants.pokemonNameFont)
                            .fontWeight(constants.pokemonNameWeight)
                            .accessibilityIdentifier(accessibilityIds.pokemonName)
                        LabeledContent(constants.heightLabelTitle, value: pokemon.height)
                            .accessibilityIdentifier(accessibilityIds.pokemonHeight)
                            .accessibilityLabel("Height: \(pokemon.height)")
                    }
                    .frame(maxWidth: constants.detailsFrameMaxWidth,
                           alignment: .leading)
                }
                .frame(maxWidth: constants.contentFrameMaxWidth)
            }
            .accessibilityIdentifier(accessibilityIds.pokemonDetailView)
        }
    }
}

struct PokemonDetailAccessibilityIdentifiers {
    let pokemonDetailView: String
    let pokemonImage: String
    let pokemonName: String
    let pokemonHeight: String
    let retryButton: String
    let loadingIndicator: String
    
    init() {
        self.pokemonDetailView = "pokemon_detail_view"
        self.pokemonImage = "pokemon_image"
        self.pokemonName = "pokemon_name"
        self.pokemonHeight = "pokemon_height"
        self.retryButton = "detail_retry_button"
        self.loadingIndicator = "detail_loading_indicator"
    }
}

struct PokemonDetailViewConstants {
    let defaultNavigationTitle: String
    let loadingMessage: String
    let errorHeadline: String
    let retryButtonTitle: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let imageShadowRadius: CGFloat
    let imageBackgroundColor: Color
    let contentSpacing: CGFloat
    let detailsSpacing: CGFloat
    let pokemonNameFont: Font
    let pokemonNameWeight: Font.Weight
    let errorSpacing: CGFloat
    let errorHeadlineFont: Font
    let errorMessageFont: Font
    let errorMessageStyle: Color
    let errorFrameMaxWidth: CGFloat
    let errorFrameMaxHeight: CGFloat
    let contentFrameMaxWidth: CGFloat
    let detailsFrameMaxWidth: CGFloat
    let detailsAlignment: HorizontalAlignment
    let heightLabelTitle: String
    
    init() {
        self.defaultNavigationTitle = "Details"
        self.loadingMessage = "Loading…"
        self.errorHeadline = "Couldn't load Pokémon"
        self.retryButtonTitle = "Retry"
        self.imageWidth = 300
        self.imageHeight = 300
        self.imageShadowRadius = 8
        self.imageBackgroundColor = Color.gray
        self.contentSpacing = 16
        self.detailsSpacing = 8
        self.pokemonNameFont = .title2
        self.pokemonNameWeight = .bold
        self.errorSpacing = 12
        self.errorHeadlineFont = .headline
        self.errorMessageFont = .footnote
        self.errorMessageStyle = .secondary
        self.errorFrameMaxWidth = .infinity
        self.errorFrameMaxHeight = .infinity
        self.contentFrameMaxWidth = .infinity
        self.detailsFrameMaxWidth = .infinity
        self.detailsAlignment = .leading
        self.heightLabelTitle = "Height"
    }
}
