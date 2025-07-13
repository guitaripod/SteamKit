import Foundation

public struct SteamAPI: SteamAPIProtocol {
    private let apiKey: String
    private let baseURL = "https://api.steampowered.com"
    private let networkClient: NetworkClientProtocol

    public init(apiKey: String, networkClient: NetworkClientProtocol = URLSessionNetworkClient()) {
        self.apiKey = apiKey
        self.networkClient = networkClient
    }

    public func getPlayerSummaries(steamIDs: [String]) async throws -> [PlayerSummary] {
        let endpoint = "\(baseURL)/ISteamUser/GetPlayerSummaries/v0002/"
        let parameters = ["key": apiKey, "steamids": steamIDs.joined(separator: ",")]
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        let response = try JSONDecoder().decode(PlayerSummariesResponse.self, from: data)
        return response.response.players
    }

    public func getFriendList(steamID: String) async throws -> [Friend] {
        let endpoint = "\(baseURL)/ISteamUser/GetFriendList/v0001/"
        let parameters = ["key": apiKey, "steamid": steamID, "relationship": "friend"]
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        let response = try JSONDecoder().decode(FriendListResponse.self, from: data)
        return response.friendslist.friends
    }

    public func getOwnedGames(steamID: String) async throws -> [OwnedGame] {
        let endpoint = "\(baseURL)/IPlayerService/GetOwnedGames/v0001/"
        let parameters = ["key": apiKey, "steamid": steamID, "include_appinfo": "1", "include_played_free_games": "1"]
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        let response = try JSONDecoder().decode(OwnedGamesResponse.self, from: data)
        return response.response.games ?? []
    }

    public func getPlayerAchievements(steamID: String, appID: Int) async throws -> [Achievement] {
        let endpoint = "\(baseURL)/ISteamUserStats/GetPlayerAchievements/v0001/"
        let parameters = ["key": apiKey, "steamid": steamID, "appid": String(appID)]
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        let response = try JSONDecoder().decode(PlayerAchievementsResponse.self, from: data)
        return response.playerstats.achievements
    }

    public func getNewsForApp(steamID: String, appID: Int) async throws -> [NewsItem] {
        let endpoint = "\(baseURL)/ISteamNews/GetNewsForApp/v0002/"
        let parameters = ["key": apiKey, "steamid": steamID, "appid": String(appID)]
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        let response = try JSONDecoder().decode(NewsForAppResponse.self, from: data)
        return response.appnews.newsitems
    }

    public func getGlobalAchievementPercentagesForApp(gameID: Int) async throws -> [GlobalAchievementPercentage] {
        let endpoint = "\(baseURL)/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/"
        let parameters = ["gameid": String(gameID)]
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        let response = try JSONDecoder().decode(GlobalAchievementPercentagesResponse.self, from: data)
        return response.achievementpercentages.achievements
    }

    public func getRecentlyPlayedGames(steamID: String, count: Int? = nil) async throws -> [RecentlyPlayedGame] {
        let endpoint = "\(baseURL)/IPlayerService/GetRecentlyPlayedGames/v0001/"
        var parameters = ["key": apiKey, "steamid": steamID]
        if let count = count {
            parameters["count"] = String(count)
        }
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        let response = try JSONDecoder().decode(RecentlyPlayedGamesResponse.self, from: data)
        return response.response.games
    }

    public func getUserStatsForGame(steamID: String, appID: Int) async throws -> UserStatsForGame {
        let endpoint = "\(baseURL)/ISteamUserStats/GetUserStatsForGame/v0002/"
        let parameters = ["key": apiKey, "steamid": steamID, "appid": String(appID)]
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        return try JSONDecoder().decode(UserStatsForGame.self, from: data)
    }

    public func getSchemaForGame(appID: Int) async throws -> GameSchema {
        let endpoint = "\(baseURL)/ISteamUserStats/GetSchemaForGame/v2/"
        let parameters = ["key": apiKey, "appid": String(appID)]
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        let response = try JSONDecoder().decode(GameSchemaResponse.self, from: data)
        return response.game
    }

    public func getPlayerBans(steamIDs: [String]) async throws -> [PlayerBans] {
        let endpoint = "\(baseURL)/ISteamUser/GetPlayerBans/v1/"
        let parameters = ["key": apiKey, "steamids": steamIDs.joined(separator: ",")]
        let data = try await networkClient.performRequest(url: endpoint, parameters: parameters)
        let response = try JSONDecoder().decode(PlayerBansResponse.self, from: data)
        return response.players
    }
}
