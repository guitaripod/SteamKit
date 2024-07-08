import Foundation

/// Represents the response structure for player bans.
public struct PlayerBansResponse: Codable {
    /// An array of PlayerBans objects.
    public let players: [PlayerBans]
}

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

    /// Returns true if the player has any type of ban.
    public var hasAnyBan: Bool {
        CommunityBanned || VACBanned || NumberOfGameBans > 0 || EconomyBan != "none"
    }

    /// Returns a summary of the player's ban status.
    public var banSummary: String {
        var summary = [String]()
        if CommunityBanned { summary.append("Community") }
        if VACBanned { summary.append("VAC (\(NumberOfVACBans))") }
        if NumberOfGameBans > 0 { summary.append("Game (\(NumberOfGameBans))") }
        if EconomyBan != "none" { summary.append("Economy") }
        return summary.isEmpty ? "No bans" : summary.joined(separator: ", ")
    }

    /// Returns the date of the last ban, if any.
    public var lastBanDate: Date? {
        guard DaysSinceLastBan > 0 else { return nil }
        return Calendar.current.date(byAdding: .day, value: -DaysSinceLastBan, to: Date())
    }

    /// Returns a formatted string of how long ago the last ban was issued.
    public var timeSinceLastBan: String {
        guard let lastBanDate = lastBanDate else { return "N/A" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: lastBanDate, relativeTo: Date())
    }

    /// Returns the severity level of the player's ban status.
    public var banSeverity: BanSeverity {
        if CommunityBanned || VACBanned {
            return .severe
        } else if NumberOfGameBans > 0 || EconomyBan != "none" {
            return .moderate
        } else {
            return .none
        }
    }

    /// Enum representing the severity of a player's ban status.
    public enum BanSeverity: String {
        case severe = "Severe"
        case moderate = "Moderate"
        case none = "None"
    }
}
