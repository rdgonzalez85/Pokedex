import XCTest
@testable import Pokedex

@MainActor
final class PokemonListViewModelTests: XCTestCase {
    var viewModel: PokemonListViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = PokemonListViewModel(service: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.state, .loading)
    }
    
    func testLoadPokemonListSuccess() async {

        let namedResources = [
            TestDataFactory.makeNamedAPIResource(
                name: "bulbasaur",
                urlString: "https://pokeapi.co/api/v2/pokemon/1/"
            ),
            TestDataFactory.makeNamedAPIResource(
                name: "ivysaur",
                urlString: "https://pokeapi.co/api/v2/pokemon/2/"
            ),
            TestDataFactory.makeNamedAPIResource(
                name: "venusaur",
                urlString: "https://pokeapi.co/api/v2/pokemon/3/"
            )
        ]
        let expectedResponse = TestDataFactory.makePokemonListResponse(
            count: 3,
            results: namedResources
        )
        mockAPIService.addMockResult(expectedResponse)
        
        await viewModel.load()
        
        switch viewModel.state {
        case .loaded(let items):
            XCTAssertEqual(items.count, 3)
            XCTAssertEqual(items[0].name, "bulbasaur")
            XCTAssertEqual(items[0].id, "bulbasaur")
            XCTAssertEqual(items[1].name, "ivysaur")
            XCTAssertEqual(items[1].id, "ivysaur")
            XCTAssertEqual(items[2].name, "venusaur")
            XCTAssertEqual(items[2].id, "venusaur")
        default:
            XCTFail("Expected loaded state, got \(viewModel.state)")
        }
    }
    
    func testLoadPokemonListEmpty() async {
        let expectedResponse = TestDataFactory.makePokemonListResponse(
            count: 0,
            results: []
        )
        mockAPIService.addMockResult(expectedResponse)
        
        await viewModel.load()
        
        switch viewModel.state {
        case .loaded(let items):
            XCTAssertEqual(items.count, 0)
        default:
            XCTFail("Expected loaded state with empty items, got \(viewModel.state)")
        }
    }
    
    func testLoadPokemonListNetworkError() async {
        mockAPIService.setMockError(MockError.networkError)
        
        await viewModel.load()
        
        switch viewModel.state {
        case .failed(let message):
            XCTAssertFalse(message.isEmpty)
        default:
            XCTFail("Expected failed state, got \(viewModel.state)")
        }
    }
    
    func testCorrectRequestMade() async {
        let expectedResponse = TestDataFactory.makePokemonListResponse()
        mockAPIService.addMockResult(expectedResponse)
        
        await viewModel.load()
        
        XCTAssertEqual(mockAPIService.receivedRequests.count, 1)
        
        if let request = mockAPIService.receivedRequests.first as? Request<PokemonListResponse> {
            XCTAssertEqual(request.path, "pokemon")
            XCTAssertEqual(request.method, .get)
        } else {
            XCTFail("Expected Request<PokemonListResponse>")
        }
    }
    
    func testLoadResetsStateToLoading() async {
        mockAPIService.setMockError(MockError.networkError)
        await viewModel.load()
        
        switch viewModel.state {
        case .failed:
            break // Expected
        default:
            XCTFail("Expected failed state")
        }
        
        mockAPIService.reset()
        let expectedResponse = TestDataFactory.makePokemonListResponse()
        mockAPIService.addMockResult(expectedResponse)
        
        await viewModel.load()
        
        switch viewModel.state {
        case .loaded:
            break // Expected
        default:
            XCTFail("Expected loaded state after retry")
        }
    }
    
    func testPokemonListItemMapping() async {
        let namedResources = [
            TestDataFactory.makeNamedAPIResource(
                name: "pikachu",
                urlString: "https://pokeapi.co/api/v2/pokemon/25/"
            ),
            TestDataFactory.makeNamedAPIResource(
                name: "charizard",
                urlString: "https://pokeapi.co/api/v2/pokemon/6/"
            )
        ]
        let expectedResponse = TestDataFactory.makePokemonListResponse(
            count: 2,
            results: namedResources
        )
        mockAPIService.addMockResult(expectedResponse)
        
        await viewModel.load()
        
        switch viewModel.state {
        case .loaded(let items):
            XCTAssertEqual(items.count, 2)
            
            let firstItem = items[0]
            XCTAssertEqual(firstItem.name, "pikachu")
            XCTAssertEqual(firstItem.id, "pikachu")
            
            let secondItem = items[1]
            XCTAssertEqual(secondItem.name, "charizard")
            XCTAssertEqual(secondItem.id, "charizard")
        default:
            XCTFail("Expected loaded state")
        }
    }
    
    func testMultipleLoadsOverwritePreviousResults() async {
        let firstResponse = TestDataFactory.makePokemonListResponse(
            count: 1,
            results: [TestDataFactory.makeNamedAPIResource(name: "bulbasaur")]
        )
        mockAPIService.addMockResult(firstResponse)
        
        await viewModel.load()
        
        switch viewModel.state {
        case .loaded(let items):
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items[0].name, "bulbasaur")
        default:
            XCTFail("Expected loaded state after first load")
        }
        
        mockAPIService.reset()
        let secondResponse = TestDataFactory.makePokemonListResponse(
            count: 2,
            results: [
                TestDataFactory.makeNamedAPIResource(name: "pikachu"),
                TestDataFactory.makeNamedAPIResource(name: "charizard")
            ]
        )
        mockAPIService.addMockResult(secondResponse)
        
        await viewModel.load()
        
        switch viewModel.state {
        case .loaded(let items):
            XCTAssertEqual(items.count, 2)
            XCTAssertEqual(items[0].name, "pikachu")
            XCTAssertEqual(items[1].name, "charizard")
        default:
            XCTFail("Expected loaded state after second load")
        }
    }
}
