import Foundation

/// Represents an achievement in a Steam game.
public struct Achievement: Codable {
    /// The API name of the achievement.
    public let apiname: String

    /// Indicates whether the achievement has been achieved (1) or not (0).
    public let achieved: Int

    /// Returns true if the achievement has been unlocked.
    public var isUnlocked: Bool {
        achieved == 1
    }

    /// Returns a user-friendly status string for the achievement.
    public var status: String {
        isUnlocked ? "Unlocked" : "Locked"
    }
}

/// Represents the response structure for player achievements.
public struct PlayerAchievementsResponse: Codable {
    /// The player stats containing achievements.
    public let playerstats: PlayerStats
}

/// Represents player statistics including achievements.
public struct PlayerStats: Codable {
    /// The Steam ID of the player.
    public let steamID: String

    /// The name of the game.
    public let gameName: String

    /// An array of achievements for the player in this game.
    public let achievements: [Achievement]

    /// Returns the total number of achievements for the game.
    public var totalAchievements: Int {
        achievements.count
    }

    /// Returns the number of unlocked achievements.
    public var unlockedAchievements: Int {
        achievements.filter { $0.isUnlocked }.count
    }

    /// Returns the percentage of achievements unlocked.
    public var achievementCompletionPercentage: Double {
        guard totalAchievements > 0 else { return 0 }
        return Double(unlockedAchievements) / Double(totalAchievements) * 100
    }
}
