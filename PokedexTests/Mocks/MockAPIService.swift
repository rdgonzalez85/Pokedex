import Foundation
@testable import Pokedex

final class MockAPIService: APIServiceProtocol {
    private var mockResults: [Any] = []
    private var mockError: Error?
    private(set) var receivedRequests: [Any] = []
    
    init() {}
    
    func performRequest<Value: Decodable>(_ request: Request<Value>) async throws -> Value {
        receivedRequests.append(request)
        
        if let error = mockError {
            throw error
        }
        
        // Find and remove the first matching result
        guard let index = mockResults.firstIndex(where: { $0 is Value }) else {
            throw MockError.noMoreMockResults(expectedType: String(describing: Value.self), path: request.path)
        }
        
        let mockResult = mockResults.remove(at: index)
        guard let result = mockResult as? Value else {
            fatalError("Mock result type mismatch for \(Value.self). This should never happen.")
        }
        
        return result
    }
    
    func addMockResult<T: Decodable>(_ result: T) {
        self.mockResults.append(result)
    }
    
    func setMockError(_ error: Error) {
        self.mockError = error
        self.mockResults.removeAll()
    }
    
    func reset() {
        mockResults.removeAll()
        mockError = nil
        receivedRequests = []
    }
    
    func hasMockResults<T: Decodable>(of type: T.Type) -> Bool {
        return mockResults.contains { $0 is T }
    }
    
    func mockResultsCount<T: Decodable>(of type: T.Type) -> Int {
        return mockResults.filter { $0 is T }.count
    }
}

enum MockError: Error, Equatable {
    case noMoreMockResults(expectedType: String, path: String)
    case networkError
    case decodingError
}
