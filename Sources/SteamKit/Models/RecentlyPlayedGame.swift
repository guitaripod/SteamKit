import Foundation

/// Represents a recently played game by a Steam user.
public struct RecentlyPlayedGame: Codable {
    /// The app ID of the game.
    public let appid: Int

    /// The name of the game.
    public let name: String

    /// The playtime in the last two weeks, in minutes.
    public let playtime_2weeks: Int

    /// The total playtime, in minutes.
    public let playtime_forever: Int

    /// The URL of the game's icon image.
    public let img_icon_url: String
}

/// Represents the response structure for recently played games.
struct RecentlyPlayedGamesResponse: Codable {
    /// The response container.
    let response: RecentlyPlayedGamesResult
}

/// Contains the result of a recently played games request.
struct RecentlyPlayedGamesResult: Codable {
    /// The total count of recently played games.
    let total_count: Int

    /// An array of RecentlyPlayedGame objects.
    let games: [RecentlyPlayedGame]
}
