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
/// ```
public protocol SteamAPIProtocol {
    /// Retrieves player summaries for the given Steam IDs.
    /// - Parameter steamIDs: An array of Steam ID strings.
    /// - Returns: An array of PlayerSummary objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let summaries = try await steamAPI.getPlayerSummaries(steamIDs: ["76561197960435530"])
    /// for summary in summaries {
    ///     print("Player: \(summary.personaname), Status: \(summary.onlineStatus)")
    /// }
    /// ```
    func getPlayerSummaries(steamIDs: [String]) async throws -> [PlayerSummary]

    /// Retrieves the friend list for a given Steam ID.
    /// - Parameter steamID: A Steam ID string.
    /// - Returns: An array of Friend objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let friends = try await steamAPI.getFriendList(steamID: "76561197960435530")
    /// print("Friend count: \(friends.count)")
    /// for friend in friends {
    ///     print("Friend: \(friend.steamid), Since: \(friend.friendshipDuration)")
    /// }
    /// ```
    func getFriendList(steamID: String) async throws -> [Friend]

    /// Retrieves the list of owned games for a given Steam ID.
    /// - Parameter steamID: A Steam ID string.
    /// - Returns: An array of OwnedGame objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let ownedGames = try await steamAPI.getOwnedGames(steamID: "76561197960435530")
    /// print("Total games: \(ownedGames.count)")
    /// for game in ownedGames.prefix(5) {
    ///     print("Game: \(game.name ?? "Unknown"), Playtime: \(game.totalPlaytimeHours) hours")
    /// }
    /// ```
    func getOwnedGames(steamID: String) async throws -> [OwnedGame]

    /// Retrieves the achievements for a player in a specific game.
    /// - Parameters:
    ///   - steamID: A Steam ID string.
    ///   - appID: The app ID of the game.
    /// - Returns: An array of Achievement objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let achievements = try await steamAPI.getPlayerAchievements(steamID: "76561197960435530", appID: 440)
    /// print("Total achievements: \(achievements.count)")
    /// for achievement in achievements.prefix(5) {
    ///     print("Achievement: \(achievement.apiname), Unlocked: \(achievement.isUnlocked)")
    /// }
    /// ```
    func getPlayerAchievements(steamID: String, appID: Int) async throws -> [Achievement]

    /// Retrieves news articles for a specific app.
    /// - Parameters:
    ///   - steamID: A Steam ID string.
    ///   - appID: The app ID of the game.
    /// - Returns: An array of NewsItem objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let news = try await steamAPI.getNewsForApp(steamID: "76561197960435530", appID: 440)
    /// for item in news.prefix(3) {
    ///     print("Title: \(item.title)")
    ///     print("URL: \(item.url)")
    ///     print("---")
    /// }
    /// ```
    func getNewsForApp(steamID: String, appID: Int) async throws -> [NewsItem]

    /// Retrieves the global achievement percentages for a specific game.
    /// - Parameter gameID: The game ID to get achievement percentages for.
    /// - Returns: An array of GlobalAchievementPercentage objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let globalAchievements = try await steamAPI.getGlobalAchievementPercentagesForApp(gameID: 440)
    /// for achievement in globalAchievements.prefix(5) {
    ///     print("\(achievement.name): \(achievement.formattedPercentage) (\(achievement.rarity))")
    /// }
    /// ```
    func getGlobalAchievementPercentagesForApp(gameID: Int) async throws -> [GlobalAchievementPercentage]

    /// Retrieves the list of recently played games for a given Steam ID.
    /// - Parameters:
    ///   - steamID: A Steam ID string.
    ///   - count: Optional number of games to return.
    /// - Returns: An array of RecentlyPlayedGame objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let recentGames = try await steamAPI.getRecentlyPlayedGames(steamID: "76561197960435530", count: 5)
    /// for game in recentGames {
    ///     print("\(game.name): \(game.recentPlaytime) in the last 2 weeks")
    /// }
    /// ```
    func getRecentlyPlayedGames(steamID: String, count: Int?) async throws -> [RecentlyPlayedGame]

    /// Retrieves a player's stats for a specific game.
    /// - Parameters:
    ///   - steamID: A Steam ID string.
    ///   - appID: The app ID of the game.
    /// - Returns: A UserStatsForGame object.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let stats = try await steamAPI.getUserStatsForGame(steamID: "76561197960435530", appID: 440)
    /// print("Game: \(stats.gameName)")
    /// print("Achievement completion: \(stats.achievementCompletionPercentage)%")
    /// for stat in stats.statsSortedByValue.prefix(5) {
    ///     print("\(stat.name): \(stat.value)")
    /// }
    /// ```
    func getUserStatsForGame(steamID: String, appID: Int) async throws -> UserStatsForGame

    /// Retrieves the schema for a specific game.
    /// - Parameter appID: The app ID of the game.
    /// - Returns: A GameSchema object.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let schema = try await steamAPI.getSchemaForGame(appID: 440)
    /// print("Game: \(schema.gameName)")
    /// print("Version: \(schema.gameVersion)")
    /// print("Total stats: \(schema.totalStats)")
    /// print("Total achievements: \(schema.totalAchievements)")
    /// ```
    func getSchemaForGame(appID: Int) async throws -> GameSchema

    /// Retrieves the ban statuses for given Steam IDs.
    /// - Parameter steamIDs: An array of Steam ID strings.
    /// - Returns: An array of PlayerBans objects.
    /// - Throws: A SteamKitError if the request fails or the response can't be decoded.
    ///
    /// Example:
    /// ```swift
    /// let bans = try await steamAPI.getPlayerBans(steamIDs: ["76561197960435530", "76561197960435531"])
    /// for ban in bans {
    ///     print("Player \(ban.SteamId)")
    ///     print("Ban summary: \(ban.banSummary)")
    ///     print("Ban severity: \(ban.banSeverity)")
    ///     print("---")
    /// }
    /// ```
    func getPlayerBans(steamIDs: [String]) async throws -> [PlayerBans]
}
