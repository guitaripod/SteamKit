import Foundation
import Testing

@testable import SteamKit

struct SteamAPITests {
    
    @Test func testPlayerSummaries() throws {
        let response: PlayerSummariesResponse = try decodeJSON(
            PlayerSummariesResponse.self,
            from: "player_summaries_response"
        )
        
        #expect(response.response.players.count == 1)
        
        let playerSummary = try #require(response.response.players.first)
        #expect(playerSummary.steamid == "76561198025885249")
        #expect(playerSummary.communityvisibilitystate == 3)
        #expect(playerSummary.profilestate == 1)
        #expect(playerSummary.personaname == "V")
        #expect(playerSummary.profileurl == URL(string: "https://steamcommunity.com/id/kratos42069/"))
        #expect(playerSummary.avatar == URL(string: "https://avatars.steamstatic.com/a521352ec938d97a89f4b9655f75924d3cea6344.jpg"))
        #expect(playerSummary.avatarmedium == URL(string: "https://avatars.steamstatic.com/a521352ec938d97a89f4b9655f75924d3cea6344_medium.jpg"))
        #expect(playerSummary.avatarfull == URL(string: "https://avatars.steamstatic.com/a521352ec938d97a89f4b9655f75924d3cea6344_full.jpg"))
        #expect(playerSummary.lastlogoff == 1_720_361_031)
        #expect(playerSummary.personastate == 4)
        #expect(playerSummary.primaryclanid == "103582791429521408")
        #expect(playerSummary.timecreated == 1_274_786_706)
        #expect(playerSummary.personastateflags == 0)
        #expect(playerSummary.loccountrycode == "US")
        #expect(playerSummary.locstatecode == "CA")
    }
    
    @Test func testOwnedGames() throws {
        let response: OwnedGamesResponse = try decodeJSON(
            OwnedGamesResponse.self,
            from: "user_owned_games_response"
        )
        
        #expect(response.response.game_count == 418)
        #expect(response.response.games.count == 418)
        
        let firstGame = try #require(response.response.games.first)
        #expect(firstGame.appid == 10)
        #expect(firstGame.name == "Counter-Strike")
        #expect(firstGame.playtime_forever == 2177)
        #expect(firstGame.img_icon_url == "6b0312cda02f5f777efa2f3318c307ff9acafbb5")
        #expect(firstGame.img_icon_url_url == URL(string: "6b0312cda02f5f777efa2f3318c307ff9acafbb5"))
        #expect(firstGame.playtime_windows_forever == 0)
        #expect(firstGame.playtime_mac_forever == 0)
        #expect(firstGame.playtime_linux_forever == 0)
        
        let dota2 = try #require(response.response.games.first { $0.appid == 570 })
        #expect(dota2.name == "Dota 2")
        #expect(dota2.playtime_forever == 23517)
        #expect(dota2.playtime_windows_forever == 891)
    }
    
    @Test func testNews() throws {
        let response: NewsForAppResponse = try decodeJSON(
            NewsForAppResponse.self,
            from: "news_response"
        )
        
        #expect(response.appnews.appid == 292030)
        #expect(response.appnews.newsitems.count == 20)
        
        let firstNewsItem = try #require(response.appnews.newsitems.first)
        #expect(firstNewsItem.gid == "5842939267344677906")
        #expect(firstNewsItem.title == "Witcher 3 mod restores cut boat-racing quests")
        #expect(firstNewsItem.url.absoluteString == "https://steamstore-a.akamaihd.net/news/externalpost/PC%20Gamer/5842939267344677906")
        #expect(firstNewsItem.is_external_url)
        #expect(firstNewsItem.author == "Jody Macgregor")
        #expect(firstNewsItem.contents.starts(with: "<img src=\"https://cdn.mos.cms.futurecdn.net/ePdQwZjBaqzcr82pZKCJwT.jpg\"/>"))
        #expect(firstNewsItem.feedlabel == "PC Gamer")
        #expect(firstNewsItem.date == 1720326072)
        #expect(firstNewsItem.feedname == "PC Gamer")
    }
    
    private func decodeJSON<T: Decodable>(_ type: T.Type, from filename: String) throws -> T {
        let url = try #require(Bundle.module.url(forResource: filename, withExtension: "json"))
        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: jsonData)
    }
}
