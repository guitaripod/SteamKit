import Foundation

/// Represents the user statistics for a specific game.
public struct UserStatsForGame: Codable {
    /// The Steam ID of the user.
    public let steamID: String

    /// The name of the game.
    public let gameName: String

    /// An array of user statistics for the game.
    public let stats: [UserGameStat]

    /// An array of user achievements for the game.
    public let achievements: [UserAchievement]

    /// Returns the total number of statistics for the game.
    public var totalStats: Int {
        stats.count
    }

    /// Returns the total number of achievements for the game.
    public var totalAchievements: Int {
        achievements.count
    }

    /// Returns the number of unlocked achievements.
    public var unlockedAchievements: Int {
        achievements.filter { $0.achieved == 1 }.count
    }

    /// Returns the percentage of achievements unlocked.
    public var achievementCompletionPercentage: Double {
        guard totalAchievements > 0 else { return 0 }
        return Double(unlockedAchievements) / Double(totalAchievements) * 100
    }

    /// Returns a dictionary of stats, keyed by their names for easy access.
    public var statsDictionary: [String: Int] {
        Dictionary(uniqueKeysWithValues: stats.map { ($0.name, $0.value) })
    }

    /// Returns the stats sorted by value in descending order.
    public var statsSortedByValue: [UserGameStat] {
        stats.sorted { $0.value > $1.value }
    }

    /// Returns the most recently unlocked achievement, if any.
    public var mostRecentAchievement: UserAchievement? {
        achievements.filter { $0.achieved == 1 }.max(by: { $0.unlockTime ?? 0 < $1.unlockTime ?? 0 })
    }
}

/// Represents a user's statistic for a game.
public struct UserGameStat: Codable {
    /// The name of the statistic.
    public let name: String

    /// The value of the statistic.
    public let value: Int
}

/// Represents a user's achievement for a game.
public struct UserAchievement: Codable {
    /// The name of the achievement.
    public let name: String

    /// Indicates whether the achievement has been achieved (1) or not (0).
    public let achieved: Int

    /// The Unix timestamp when the achievement was unlocked (if available).
    public let unlockTime: Int?

    /// Returns true if the achievement has been unlocked.
    public var isUnlocked: Bool {
        achieved == 1
    }

    /// Returns the unlock date of the achievement, if available.
    public var unlockDate: Date? {
        guard let unlockTime = unlockTime else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(unlockTime))
    }

    /// Returns a formatted string of when the achievement was unlocked.
    public var unlockDateFormatted: String {
        guard let unlockDate = unlockDate else { return "Not unlocked" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: unlockDate)
    }
}
