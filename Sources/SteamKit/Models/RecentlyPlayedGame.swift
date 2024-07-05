import Foundation

public struct RecentlyPlayedGame: Codable {
    public let appid: Int
    public let name: String
    public let playtime_2weeks: Int
    public let playtime_forever: Int
    public let img_icon_url: String
}

struct RecentlyPlayedGamesResponse: Codable {
    let response: RecentlyPlayedGamesResult
}

struct RecentlyPlayedGamesResult: Codable {
    let total_count: Int
    let games: [RecentlyPlayedGame]
}
