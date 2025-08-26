import Foundation

@MainActor
final class PokemonListViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded(items: [PokemonListItem])
        case failed(message: String)
    }

    @Published private(set) var state: State = .loading

    private let service: APIServiceProtocol
    private var items: [PokemonListItem] = []

    init(service: APIServiceProtocol = APIService()) {
        self.service = service
    }

    func load() async {
        state = .loading
        do {
            let results = try await service.performRequest(PokemonListResponse.list).results
            items = results.compactMap {
                PokemonListItem(namedAPIResource: $0)
            }
            state = .loaded(items: items)
        } catch {
            state = .failed(message: (error as NSError).localizedDescription)
        }
    }
}
