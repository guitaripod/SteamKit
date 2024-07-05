import Foundation

public struct Achievement: Codable {
    public let apiname: String
    public let achieved: Int
}

struct PlayerAchievementsResponse: Codable {
    let playerstats: PlayerStats
}

struct PlayerStats: Codable {
    let steamID: String
    let gameName: String
    let achievements: [Achievement]
}
