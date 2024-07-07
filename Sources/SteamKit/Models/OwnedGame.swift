import Foundation

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
    public let content_descriptorids: [Int]?
    public let has_leaderboards: Bool?
    public let playtime_disconnected: Int?
    
    /// Computed property to get URL if valid
    public var img_icon_url_url: URL? {
        guard let urlString = img_icon_url else { return nil }
        return URL(string: urlString)
    }
}

struct OwnedGamesResponse: Codable {
    let response: OwnedGamesResult
}

struct OwnedGamesResult: Codable {
    let game_count: Int
    let games: [OwnedGame]
}
