import Foundation

/// Represents the user statistics for a specific game.
public struct UserStatsForGame: Codable {
    /// The Steam ID of the user.
    public let steamID: String

    /// The name of the game.
    public let gameName: String

    /// An array of statistics for the game.
    public let stats: [Stat]

    /// An array of achievements for the game.
    public let achievements: [Achievement]
}

/// Represents a statistic for a game.
public struct Stat: Codable {
    /// The name of the statistic.
    public let name: String

    /// The value of the statistic.
    public let value: Int
}
