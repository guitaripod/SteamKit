import Foundation

/// Represents an achievement in a Steam game.
public struct Achievement: Codable {
    /// The API name of the achievement.
    public let apiname: String

    /// Indicates whether the achievement has been achieved (1) or not (0).
    public let achieved: Int
}

/// Represents the response structure for player achievements.
struct PlayerAchievementsResponse: Codable {
    /// The player stats containing achievements.
    let playerstats: PlayerStats
}

/// Represents player statistics including achievements.
struct PlayerStats: Codable {
    /// The Steam ID of the player.
    let steamID: String

    /// The name of the game.
    let gameName: String

    /// An array of achievements for the player in this game.
    let achievements: [Achievement]
}
