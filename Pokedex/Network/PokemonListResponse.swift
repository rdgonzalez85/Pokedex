import Foundation

struct PokemonListResponse: Codable, Equatable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [NamedAPIResource]
}

struct NamedAPIResource: Codable, Equatable, Identifiable {
    let name: String
    let url: URL

    var id: String { name } // pokeapi guarantees unique names
}

struct PokemonDetail: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let sprites: Sprites

    struct Sprites: Codable, Equatable {
        let front_default: URL?
        let other: OtherSprites?

        struct OtherSprites: Codable, Equatable {
            let officialArtwork: OfficialArtwork?

            enum CodingKeys: String, CodingKey {
                case officialArtwork = "official-artwork"
            }

            struct OfficialArtwork: Codable, Equatable {
                let front_default: URL?
            }
        }

        var preferredImageURL: URL? {
            other?.officialArtwork?.front_default ?? front_default
        }
    }
}
