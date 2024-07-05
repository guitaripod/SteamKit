import Foundation

public struct PlayerSummary: Codable {
    public let steamid: String
    public let communityvisibilitystate: Int
    public let profilestate: Int
    public let personaname: String
    public let profileurl: String
    public let avatar: String
    public let avatarmedium: String
    public let avatarfull: String
    public let lastlogoff: Int
    public let personastate: Int
    public let realname: String?
    public let primaryclanid: String?
    public let timecreated: Int?
    public let personastateflags: Int?
    public let loccountrycode: String?
    public let locstatecode: String?
}

struct PlayerSummariesResponse: Codable {
    let response: PlayerSummariesResult
}

struct PlayerSummariesResult: Codable {
    let players: [PlayerSummary]
}
