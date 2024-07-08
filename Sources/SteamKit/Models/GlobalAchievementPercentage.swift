import Foundation

/// Represents the global achievement percentage for a game.
public struct GlobalAchievementPercentage: Codable {
    /// The name of the achievement.
    public let name: String

    /// The percentage of players who have unlocked this achievement.
    public let percent: Double
}

/// Represents the response structure for global achievement percentages.
struct GlobalAchievementPercentagesResponse: Codable {
    /// The achievement percentages container.
    let achievementpercentages: AchievementPercentages
}

/// Contains the list of global achievement percentages.
struct AchievementPercentages: Codable {
    /// An array of GlobalAchievementPercentage objects.
    let achievements: [GlobalAchievementPercentage]
}
