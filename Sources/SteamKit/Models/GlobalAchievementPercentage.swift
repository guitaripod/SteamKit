import Foundation

public struct GlobalAchievementPercentage: Codable {
    public let name: String
    public let percent: Double
}

struct GlobalAchievementPercentagesResponse: Codable {
    let achievementpercentages: AchievementPercentages
}

struct AchievementPercentages: Codable {
    let achievements: [GlobalAchievementPercentage]
}
