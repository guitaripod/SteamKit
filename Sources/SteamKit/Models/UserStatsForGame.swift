import Foundation

public struct UserStatsForGame: Codable {
    public let steamID: String
    public let gameName: String
    public let stats: [Stat]
    public let achievements: [Achievement]
}

public struct Stat: Codable {
    public let name: String
    public let value: Int
}
