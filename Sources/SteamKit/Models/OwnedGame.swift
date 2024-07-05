import Foundation

public struct OwnedGame: Codable {
    public let appid: Int
    public let name: String?
    public let playtime_forever: Int
    public let img_icon_url: String?
    public let playtime_windows_forever: Int
    public let playtime_mac_forever: Int
    public let playtime_linux_forever: Int
}

struct OwnedGamesResponse: Codable {
    let response: OwnedGamesResult
}

struct OwnedGamesResult: Codable {
    let game_count: Int
    let games: [OwnedGame]
}
