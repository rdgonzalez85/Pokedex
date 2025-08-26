import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol APIServiceProtocol {
    func performRequest<Value: Decodable>(_ request: Request<Value>) async throws -> Value
}

enum APIServiceError: Error {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError(let error):
            return error.localizedDescription
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}

final class APIService: APIServiceProtocol {
    private let urlSession: URLSessionProtocol
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    private let baseURL: String
    private let constants: APIConstants
    
    init(
        urlSession: URLSessionProtocol = URLSession.shared,
        constants: APIConstants = APIConstants(),
        baseURL: String = "https://pokeapi.co/api/v2/"
    ) {
        self.urlSession = urlSession
        self.constants = constants
        self.baseURL = baseURL
    }
    
    private func createURLRequest<Value: Decodable>(
        request: Request<Value>
    ) throws -> URLRequest {
        let endpoint = self.baseURL + request.path
        guard let url = URL(string: endpoint) else {
            throw APIServiceError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.setValue(self.constants.acceptHeaderValue, forHTTPHeaderField: self.constants.acceptHeaderField)
                
        return urlRequest
    }
    
    func performRequest<Value: Decodable>(
        _ request: Request<Value>
    ) async throws -> Value {
        let request = try self.createURLRequest(request: request)

        do {
            let (data, _) = try await self.urlSession.data(for: request)
            return try self.jsonDecoder.decode(Value.self, from: data)
        } catch let decodingError as DecodingError {
            throw APIServiceError.decodingError(decodingError)
        } catch {
            throw APIServiceError.networkError(error)
        }
    }
}

struct APIConstants {
    // HTTP Headers
    let acceptHeaderValue = "application/json"
    let acceptHeaderField = "Accept"
}
