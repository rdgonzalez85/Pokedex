import Foundation

struct Request<Value: Decodable> {
    enum Method: String {
        case get = "GET"
    }
    
    let method: Method
    let path: String
    
    init(
        method: Method = .get,
        path: String
    ) {
        self.method = method
        self.path = path
    }
}

extension PokemonListResponse {    
    static let list: Request<PokemonListResponse> =
        Request(path: "pokemon")
}

extension PokemonDetail {
    static func pokemon(name: String) -> Request<PokemonDetail> {
        Request(path: "pokemon/\(name)")
    }
}
