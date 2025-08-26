import Foundation
@testable import Pokedex

final class TestDataFactory {
    static func createHTTPResponse(
        statusCode: Int = 200,
        urlString: String = "/resource.json",
        headerFields: [String : String]? = nil
    ) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: urlString)!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headerFields
        )!
    }
    
    static func makePokemonListResponse(
        count: Int = 10,
        next: URL? = nil,
        previous: URL? = nil,
        results: [NamedAPIResource]? = nil
    ) -> PokemonListResponse {
        .init(
            count: count,
            next: next,
            previous: previous,
            results: results ?? [Self.makeNamedAPIResource()]
        )
    }
    
    static func makeNamedAPIResource(
        name: String = "name",
        urlString: String = "/path/to/file.json"
    ) -> NamedAPIResource {
        .init(
            name: name,
            url: URL(string: urlString)!
        )
    }
    
    static func makePokemonDetail(
        id: Int = 1,
        name: String = "Pikachu",
        height: Int = 10,
        sprites: PokemonDetail.Sprites? = nil
    ) -> PokemonDetail {
        return .init(
            id: id,
            name: name,
            height: height,
            sprites: sprites ?? Self.makeSprites()
        )
    }
    
    static func makeSprites(
        front_default: URL? = nil,
        other: PokemonDetail.Sprites.OtherSprites? = nil
    ) -> PokemonDetail.Sprites {
        return .init(
            front_default: front_default,
            other: other ?? Self.makeOtherSprites()
        )
    }
    
    static func makeOtherSprites(
        front_default: URL? = nil
    ) -> PokemonDetail.Sprites.OtherSprites {
        .init(
            officialArtwork: PokemonDetail.Sprites.OtherSprites.OfficialArtwork(
                front_default: front_default
            )
        )
    }
}
