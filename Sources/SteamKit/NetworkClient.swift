import Foundation

public protocol NetworkClientProtocol {
    func performRequest(url: String, parameters: [String: String]) async throws -> Data
}

public struct URLSessionNetworkClient: NetworkClientProtocol {
    public init() {}

    public func performRequest(url: String, parameters: [String: String]) async throws -> Data {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        let (data, response) = try await URLSession.shared.data(from: components.url!)

        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode)
        else {
            throw NetworkError.invalidResponse
        }

        return data
    }
}

public enum NetworkError: Error {
    case invalidResponse
    case invalidURL
    case decodingError
}
