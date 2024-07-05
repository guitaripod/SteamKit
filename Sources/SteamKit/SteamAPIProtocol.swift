import Foundation

/// Protocol defining the interface for Steam API operations.
///
/// Usage:
/// ```swift
/// import SteamKit
///
/// let steamAPI: SteamAPIProtocol = SteamAPI(apiKey: "YOUR_API_KEY")
///
/// Task {
///     do {
///         // Get player summaries
///         let summaries = try await steamAPI.getPlayerSummaries(steamIDs: ["76561197960435530"])
///         print("Player name: \(summaries.first?.personaname ?? "Unknown")")
///
///         // Get owned games
///         let ownedGames = try await steamAPI.getOwnedGames(steamID: "76561197960435530")
///         print("Number of owned games: \(ownedGames.count)")
///
///         // Get recent games
///         let recentGames = try await steamAPI.getRecentlyPlayedGames(steamID: "76561197960435530", count: 5)
///         print("Recently played: \(recentGames.map { $0.name }.joined(separator: ", "))")
///     } catch {
///         print("Error: \(error)")
///     }
/// }
public protocol SteamAPIProtocol {
    /// Retrieves player summaries for the given Steam IDs.
    /// - Parameter steamIDs: An array of Steam ID strings.
    /// - Returns: An array of PlayerSummary objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getPlayerSummaries(steamIDs: [String]) async throws -> [PlayerSummary]

    /// Retrieves the friend list for a given Steam ID.
    /// - Parameter steamID: A Steam ID string.
    /// - Returns: An array of Friend objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getFriendList(steamID: String) async throws -> [Friend]

    /// Retrieves the list of owned games for a given Steam ID.
    /// - Parameter steamID: A Steam ID string.
    /// - Returns: An array of OwnedGame objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getOwnedGames(steamID: String) async throws -> [OwnedGame]

    /// Retrieves the achievements for a player in a specific game.
    /// - Parameters:
    ///   - steamID: A Steam ID string.
    ///   - appID: The app ID of the game.
    /// - Returns: An array of Achievement objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getPlayerAchievements(steamID: String, appID: Int) async throws -> [Achievement]

    /// Retrieves news articles for a specific app.
    /// - Parameters:
    ///   - appID: The app ID to get news for.
    ///   - count: The number of news items to retrieve.
    ///   - maxLength: Optional maximum length for the contents field.
    /// - Returns: An array of NewsItem objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getNewsForApp(appID: Int, count: Int, maxLength: Int?) async throws -> [NewsItem]

    /// Retrieves the global achievement percentages for a specific game.
    /// - Parameter gameID: The game ID to get achievement percentages for.
    /// - Returns: An array of GlobalAchievementPercentage objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getGlobalAchievementPercentagesForApp(gameID: Int) async throws -> [GlobalAchievementPercentage]

    /// Retrieves the list of recently played games for a given Steam ID.
    /// - Parameters:
    ///   - steamID: A Steam ID string.
    ///   - count: Optional number of games to return.
    /// - Returns: An array of RecentlyPlayedGame objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getRecentlyPlayedGames(steamID: String, count: Int?) async throws -> [RecentlyPlayedGame]

    /// Retrieves a player's stats for a specific game.
    /// - Parameters:
    ///   - steamID: A Steam ID string.
    ///   - appID: The app ID of the game.
    /// - Returns: A UserStatsForGame object.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getUserStatsForGame(steamID: String, appID: Int) async throws -> UserStatsForGame

    /// Retrieves the schema for a specific game.
    /// - Parameter appID: The app ID of the game.
    /// - Returns: A GameSchema object.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getSchemaForGame(appID: Int) async throws -> GameSchema

    /// Retrieves the ban statuses for given Steam IDs.
    /// - Parameter steamIDs: An array of Steam ID strings.
    /// - Returns: An array of PlayerBans objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    func getPlayerBans(steamIDs: [String]) async throws -> [PlayerBans]
}
