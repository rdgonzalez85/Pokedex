import Foundation

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded(Pokemon)
        case failed(message: String)
    }

    @Published private(set) var state: State = .loading

    private let service: APIServiceProtocol
    private let name: String

    init(
        name: String,
        service: APIServiceProtocol = APIService()
    ) {
        self.name = name
        self.service = service
    }

    func load() async {
        state = .loading
        do {
            let detail = try await service.performRequest(PokemonDetail.pokemon(name: name))
            let pokemon = Pokemon(pokemonDetail: detail)
            
            state = .loaded(pokemon)
        } catch {
            state = .failed(message: (error as NSError).localizedDescription)
        }
    }
}
