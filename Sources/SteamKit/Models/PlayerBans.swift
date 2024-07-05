import Foundation

public struct PlayerBans: Codable {
    public let SteamId: String
    public let CommunityBanned: Bool
    public let VACBanned: Bool
    public let NumberOfVACBans: Int
    public let DaysSinceLastBan: Int
    public let NumberOfGameBans: Int
    public let EconomyBan: String
}

struct PlayerBansResponse: Codable {
    let players: [PlayerBans]
}
