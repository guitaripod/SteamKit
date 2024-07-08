import Foundation

/// Represents the response structure for recently played games.
public struct RecentlyPlayedGamesResponse: Codable {
    /// The response container.
    public let response: RecentlyPlayedGamesResult
}

/// Represents a recently played game by a Steam user.
public struct RecentlyPlayedGame: Codable {
    /// The app ID of the game.
    public let appid: Int

    /// The name of the game.
    public let name: String

    /// The playtime in the last two weeks, in minutes.
    public let playtime_2weeks: Int

    /// The total playtime, in minutes.
    public let playtime_forever: Int

    /// The URL of the game's icon image.
    public let img_icon_url: String

    /// Returns the playtime in the last two weeks as a formatted string.
    public var recentPlaytime: String {
        formatPlaytime(minutes: playtime_2weeks)
    }

    /// Returns the total playtime as a formatted string.
    public var totalPlaytime: String {
        formatPlaytime(minutes: playtime_forever)
    }

    /// Returns the percentage of total playtime that occurred in the last two weeks.
    public var recentPlaytimePercentage: Double {
        guard playtime_forever > 0 else { return 0 }
        return Double(playtime_2weeks) / Double(playtime_forever) * 100
    }

    /// Returns the full URL for the game's icon.
    public var iconURL: URL {
        URL(string: "https://media.steampowered.com/steamcommunity/public/images/apps/\(appid)/\(img_icon_url).jpg")!
    }

    /// Returns true if the game has been played in the last two weeks.
    public var playedRecently: Bool {
        playtime_2weeks > 0
    }

    /// Helper method to format playtime in minutes to a human-readable string.
    private func formatPlaytime(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        if hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") \(remainingMinutes) minute\(remainingMinutes == 1 ? "" : "s")"
        } else {
            return "\(minutes) minute\(minutes == 1 ? "" : "s")"
        }
    }
}

/// Contains the result of a recently played games request.
public struct RecentlyPlayedGamesResult: Codable {
    /// The total count of recently played games.
    public let total_count: Int

    /// An array of RecentlyPlayedGame objects.
    public let games: [RecentlyPlayedGame]

    /// Returns the total playtime across all recently played games in the last two weeks.
    public var totalRecentPlaytime: Int {
        games.reduce(0) { $0 + $1.playtime_2weeks }
    }

    /// Returns the game with the most playtime in the last two weeks.
    public var mostPlayedRecentGame: RecentlyPlayedGame? {
        games.max(by: { $0.playtime_2weeks < $1.playtime_2weeks })
    }

    /// Returns the games sorted by recent playtime (descending order).
    public var gamesSortedByRecentPlaytime: [RecentlyPlayedGame] {
        games.sorted(by: { $0.playtime_2weeks > $1.playtime_2weeks })
    }
}
