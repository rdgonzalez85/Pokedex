import Foundation

struct Pokemon: Equatable {
    let name: String
    let height: String
    let imageURL: URL?
}

extension Pokemon {
    init(pokemonDetail: PokemonDetail) {
        self.name = pokemonDetail.name
        self.height = String(pokemonDetail.height)
        self.imageURL = pokemonDetail.sprites.preferredImageURL
    }
}

struct PokemonListItem: Equatable, Identifiable {
    let name: String
    let id: String
}

extension PokemonListItem {
    init(namedAPIResource: NamedAPIResource) {
        self.name = namedAPIResource.name
        self.id = namedAPIResource.id
    }
}
