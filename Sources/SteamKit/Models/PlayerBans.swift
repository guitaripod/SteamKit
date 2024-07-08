import Foundation

/// Represents the ban status of a Steam player.
public struct PlayerBans: Codable {
    /// The Steam ID of the player.
    public let SteamId: String

    /// Indicates whether the player is banned from Steam Community.
    public let CommunityBanned: Bool

    /// Indicates whether the player has a VAC (Valve Anti-Cheat) ban.
    public let VACBanned: Bool

    /// The number of VAC bans on the player's record.
    public let NumberOfVACBans: Int

    /// The number of days since the player's last ban.
    public let DaysSinceLastBan: Int

    /// The number of game bans on the player's record.
    public let NumberOfGameBans: Int

    /// The status of the player's economy ban.
    public let EconomyBan: String
}

/// Represents the response structure for player bans.
struct PlayerBansResponse: Codable {
    /// An array of PlayerBans objects.
    let players: [PlayerBans]
}
