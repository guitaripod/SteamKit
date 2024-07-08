import Foundation

/// Represents the response structure for global achievement percentages.
public struct GlobalAchievementPercentagesResponse: Codable {
    /// The achievement percentages container.
    public let achievementpercentages: AchievementPercentages
}

/// Contains the list of global achievement percentages.
public struct AchievementPercentages: Codable {
    /// An array of GlobalAchievementPercentage objects.
    public let achievements: [GlobalAchievementPercentage]

    /// Returns the achievement with the highest unlock percentage.
    public var mostCommonAchievement: GlobalAchievementPercentage? {
        achievements.max(by: { $0.percent < $1.percent })
    }

    /// Returns the achievement with the lowest unlock percentage.
    public var rarestAchievement: GlobalAchievementPercentage? {
        achievements.min(by: { $0.percent < $1.percent })
    }

    /// Returns the average unlock percentage across all achievements.
    public var averageUnlockPercentage: Double {
        guard !achievements.isEmpty else { return 0 }
        let total = achievements.reduce(0.0) { $0 + $1.percent }
        return total / Double(achievements.count)
    }

    /// Returns a dictionary of achievements grouped by rarity.
    public var achievementsByRarity: [GlobalAchievementPercentage.Rarity: [GlobalAchievementPercentage]] {
        Dictionary(grouping: achievements) { $0.rarity }
    }
}

/// Represents the global achievement percentage for a game.
public struct GlobalAchievementPercentage: Codable {
    /// The name of the achievement.
    public let name: String

    /// The percentage of players who have unlocked this achievement.
    public let percent: Double

    /// Returns the percentage formatted as a string with two decimal places.
    public var formattedPercentage: String {
        String(format: "%.2f%%", percent)
    }

    /// Categorizes the achievement based on its unlock percentage.
    public var rarity: Rarity {
        switch percent {
        case 0..<5:
            return .ultraRare
        case 5..<10:
            return .veryRare
        case 10..<20:
            return .rare
        case 20..<50:
            return .uncommon
        default:
            return .common
        }
    }

    /// Enum representing the rarity of an achievement.
    public enum Rarity: String {
        case ultraRare = "Ultra Rare"
        case veryRare = "Very Rare"
        case rare = "Rare"
        case uncommon = "Uncommon"
        case common = "Common"
    }
}
