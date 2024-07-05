import Foundation

public struct GameSchema: Codable {
    public let gameName: String
    public let gameVersion: String
    public let availableGameStats: AvailableGameStats
}

public struct AvailableGameStats: Codable {
    public let stats: [StatSchema]
    public let achievements: [AchievementSchema]
}

public struct StatSchema: Codable {
    public let name: String
    public let defaultvalue: Int
    public let displayName: String
}

public struct AchievementSchema: Codable {
    public let name: String
    public let defaultvalue: Int
    public let displayName: String
    public let hidden: Int
    public let description: String
    public let icon: String
    public let icongray: String
}

struct GameSchemaResponse: Codable {
    let game: GameSchema
}
