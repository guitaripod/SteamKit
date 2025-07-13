import Foundation

public enum SteamKitError: Error {
    case networkError(NetworkError)
    case apiError(String)
    case decodingError(Error)
    case invalidParameters(String)
}
