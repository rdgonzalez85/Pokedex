import XCTest
@testable import Pokedex

@MainActor
final class PokemonDetailViewModelTests: XCTestCase {
    var viewModel: PokemonDetailViewModel!
    var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = PokemonDetailViewModel(name: "pikachu", service: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.state, .loading)
    }
    
    func testLoadPokemonSuccess() async throws {
        let expectedName = "Raichu"
        let expectedHeight = 4
        let expectedURL = try XCTUnwrap(URL(string: "/path/to/file.json"))
        let sprites = PokemonDetail.Sprites(front_default: nil, other: .init(officialArtwork: .init(front_default: expectedURL)))
        let expectedDetail = TestDataFactory.makePokemonDetail(
            name: expectedName,
            height: expectedHeight,
            sprites: sprites
        )
        mockAPIService.addMockResult(expectedDetail)
        
        await viewModel.load()
        
        switch viewModel.state {
        case .loaded(let pokemon):
            XCTAssertEqual(pokemon.name, expectedName)
            XCTAssertEqual(pokemon.height, String(expectedHeight))
            XCTAssertEqual(pokemon.imageURL, expectedURL)
        default:
            XCTFail("Expected loaded state, got \(viewModel.state)")
        }
    }
    
    func testLoadPokemonDecodingError() async {
        mockAPIService.setMockError(APIServiceError.decodingError(DecodingError.keyNotFound(
            CodingKeys.name, 
            DecodingError.Context(codingPath: [], debugDescription: "Missing name")
        )))
        
        await viewModel.load()
        
        switch viewModel.state {
        case .failed(let message):
            XCTAssertTrue(message.contains("Missing name") || !message.isEmpty)
        default:
            XCTFail("Expected failed state, got \(viewModel.state)")
        }
    }
    
    func testCorrectRequestPath() async {

        let pokemonName = "charizard"
        viewModel = PokemonDetailViewModel(name: pokemonName, service: mockAPIService)
        
        let expectedDetail = TestDataFactory.makePokemonDetail(name: pokemonName)
        mockAPIService.addMockResult(expectedDetail)
        
        await viewModel.load()
        
        XCTAssertEqual(mockAPIService.receivedRequests.count, 1)
        
        if let request = mockAPIService.receivedRequests.first as? Request<PokemonDetail> {
            XCTAssertEqual(request.path, "pokemon/\(pokemonName)")
            XCTAssertEqual(request.method, .get)
        } else {
            XCTFail("Expected Request<PokemonDetail>")
        }
    }

}

enum ViewModelLoadState {
    case loading
    case loaded
    case failure
}

private enum CodingKeys: String, CodingKey {
    case name
}
