import Foundation

/// Represents the schema for a game in Steam.
public struct GameSchema: Codable {
    /// The name of the game.
    public let gameName: String

    /// The version of the game.
    public let gameVersion: String

    /// The available game stats and achievements.
    public let availableGameStats: AvailableGameStats
}

/// Contains the available statistics and achievements for a game.
public struct AvailableGameStats: Codable {
    /// An array of statistic schemas for the game.
    public let stats: [StatSchema]

    /// An array of achievement schemas for the game.
    public let achievements: [AchievementSchema]
}

/// Represents the schema for a statistic in a game.
public struct StatSchema: Codable {
    /// The name of the statistic.
    public let name: String

    /// The default value of the statistic.
    public let defaultvalue: Int

    /// The display name of the statistic.
    public let displayName: String
}

/// Represents the schema for an achievement in a game.
public struct AchievementSchema: Codable {
    /// The name of the achievement.
    public let name: String

    /// The default value of the achievement.
    public let defaultvalue: Int

    /// The display name of the achievement.
    public let displayName: String

    /// Indicates whether the achievement is hidden (1) or visible (0).
    public let hidden: Int

    /// The description of the achievement.
    public let description: String

    /// The URL of the achievement's icon.
    public let icon: String

    /// The URL of the achievement's gray (locked) icon.
    public let icongray: String
}

/// Represents the response structure for a game schema request.
struct GameSchemaResponse: Codable {
    /// The game schema.
    let game: GameSchema
}
