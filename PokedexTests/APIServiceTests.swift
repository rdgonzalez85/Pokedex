import XCTest
@testable import Pokedex

final class APIServiceTests: XCTestCase {

    var apiService: APIService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        apiService = APIService(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        apiService = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testListResponse() async throws {
        let expectedListResponse = TestDataFactory.makePokemonListResponse()

        let jsonData = try JSONEncoder().encode(expectedListResponse)
        
        mockURLSession.mockData = jsonData
        mockURLSession.mockResponse = TestDataFactory.createHTTPResponse()
        
        let request = PokemonListResponse.list
        
        let listResponseResults = try await self.apiService.performRequest(request).results

        // Then
        XCTAssertEqual(expectedListResponse.results, listResponseResults)
        
        // Verify request
        XCTAssertNotNil(mockURLSession.lastRequest)
        XCTAssertEqual(mockURLSession.lastRequest?.httpMethod, "GET")
        
        let url = try XCTUnwrap(mockURLSession.lastRequest?.url)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        XCTAssertEqual(components?.url?.lastPathComponent, "pokemon")
    }
}
