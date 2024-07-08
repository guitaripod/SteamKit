import Foundation

struct OwnedGamesResponse: Codable {
    let response: OwnedGamesResult
}

public struct OwnedGame: Codable {
    public let appid: Int
    public let name: String?
    public let playtime_forever: Int
    public let img_icon_url: String?
    public let has_community_visible_stats: Bool?
    public let playtime_windows_forever: Int
    public let playtime_mac_forever: Int
    public let playtime_linux_forever: Int
    public let playtime_deck_forever: Int?
    public let rtime_last_played: Int
    public let content_descriptorids: [ContentDescriptor]?
    public let has_leaderboards: Bool?
    public let playtime_disconnected: Int?

    public enum ContentDescriptor: Int, Codable {
        case frequentViolenceOrGore = 1
        case adultOnlySexualContent = 2
        case generalMatureContent = 3

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(Int.self)
            self = ContentDescriptor(rawValue: rawValue) ?? .generalMatureContent
        }
    }

    public enum Platform: String, CaseIterable {
        case windows = "Windows"
        case mac = "Mac"
        case linux = "Linux"
        case steamDeck = "Steam Deck"
    }

    /// Returns the full URL for the game's icon.
    public var iconURL: URL? {
        guard let img_icon_url = img_icon_url else { return nil }
        return URL(
            string: "https://media.steampowered.com/steamcommunity/public/images/apps/\(appid)/\(img_icon_url).jpg")
    }

    /// Returns the total playtime across all platforms in hours.
    public var totalPlaytimeHours: Double {
        Double(playtime_forever) / 60.0
    }

    /// Returns the percentage of playtime on each platform.
    public var playtimePercentages: [Platform: Double] {
        let total = Double(
            playtime_windows_forever + playtime_mac_forever + playtime_linux_forever + (playtime_deck_forever ?? 0))
        guard total > 0 else { return [:] }

        var percentages: [Platform: Double] = [
            .windows: Double(playtime_windows_forever) / total * 100,
            .mac: Double(playtime_mac_forever) / total * 100,
            .linux: Double(playtime_linux_forever) / total * 100,
        ]

        if let deckPlaytime = playtime_deck_forever {
            percentages[.steamDeck] = Double(deckPlaytime) / total * 100
        }

        return percentages
    }

    /// Returns the date when the game was last played.
    public var lastPlayedDate: Date {
        Date(timeIntervalSince1970: TimeInterval(rtime_last_played))
    }

    /// Returns a formatted string of how long ago the game was last played.
    public var lastPlayedAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: lastPlayedDate, relativeTo: Date())
    }

    /// Returns a boolean indicating if the game has been played recently (within the last 2 weeks).
    /// - Note: Threshold is 14 days.
    public var isRecentlyPlayed: Bool {
        Date().timeIntervalSince(lastPlayedDate) < 14 * 24 * 60 * 60
    }

    /// Returns the primary platform the game is played on.
    public var primaryPlatform: Platform {
        let playtimes: [Platform: Int] = [
            .windows: playtime_windows_forever,
            .mac: playtime_mac_forever,
            .linux: playtime_linux_forever,
            .steamDeck: playtime_deck_forever ?? 0,
        ]
        return playtimes.max(by: { $0.value < $1.value })?.key ?? .windows
    }

    /// Returns true if the game has mature content.
    public var hasMatureContent: Bool {
        content_descriptorids?.contains(where: { $0 == .frequentViolenceOrGore || $0 == .adultOnlySexualContent })
            ?? false
    }
}

struct OwnedGamesResult: Codable {
    let game_count: Int?
    let games: [OwnedGame]?
}
