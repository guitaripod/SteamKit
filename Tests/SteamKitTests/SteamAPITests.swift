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
        #expect(playerSummary.communityvisibilitystate == .public)
        #expect(playerSummary.profilestate == 1)
        #expect(playerSummary.personaname == "V")
        #expect(playerSummary.profileurl == URL(string: "https://steamcommunity.com/id/kratos42069/"))
        #expect(playerSummary.avatar == URL(string: "https://avatars.steamstatic.com/a521352ec938d97a89f4b9655f75924d3cea6344.jpg"))
        #expect(playerSummary.avatarmedium == URL(string: "https://avatars.steamstatic.com/a521352ec938d97a89f4b9655f75924d3cea6344_medium.jpg"))
        #expect(playerSummary.avatarfull == URL(string: "https://avatars.steamstatic.com/a521352ec938d97a89f4b9655f75924d3cea6344_full.jpg"))
        #expect(playerSummary.lastlogoff == 1_720_361_031)
        #expect(playerSummary.personastate == .snooze)
        #expect(playerSummary.primaryclanid == "103582791429521408")
        #expect(playerSummary.timecreated == 1_274_786_706)
        #expect(playerSummary.personastateflags == [])
        #expect(playerSummary.loccountrycode == "US")
        #expect(playerSummary.locstatecode == "CA")
        
        // Test computed properties
        #expect(playerSummary.displayName == "V")
        #expect(playerSummary.isProfilePublic == true)
        #expect(playerSummary.onlineStatus == "Snooze")
        #expect(playerSummary.isUsingVR == false)
        #expect(playerSummary.currentClientType == "Desktop")
        
        // Test creation date
        let expectedCreationDate = Date(timeIntervalSince1970: 1_274_786_706)
        #expect(playerSummary.creationDate == expectedCreationDate)
        
        // Test last logoff date
        let expectedLastLogoffDate = Date(timeIntervalSince1970: 1_720_361_031)
        #expect(playerSummary.lastLogoffDate == expectedLastLogoffDate)
        
        // Note: We can't test exact strings for accountAge and timeSinceLastLogoff
        // as they depend on the current date when the test is run.
        // Instead, we can check that they're not empty
        #expect(!playerSummary.accountAge.isEmpty)
        #expect(!playerSummary.timeSinceLastLogoff.isEmpty)
    }
    
    @Test func testOwnedGames() throws {
        let response: OwnedGamesResponse = try decodeJSON(
            OwnedGamesResponse.self,
            from: "user_owned_games_response"
        )
        
        #expect(response.response.game_count == 418)
        #expect(response.response.games.count == 418)
        
        let ffXIII = try #require(response.response.games.first { $0.appid == 292120 })
        #expect(ffXIII.appid == 292120)
        #expect(ffXIII.name == "FINAL FANTASY XIII")
        #expect(ffXIII.playtime_forever == 7412)
        #expect(ffXIII.img_icon_url == "83c929d4965963f6e0bc17969a2599e7829ac23d")
        #expect(ffXIII.has_community_visible_stats == true)
        #expect(ffXIII.playtime_windows_forever == 1737)
        #expect(ffXIII.playtime_mac_forever == 0)
        #expect(ffXIII.playtime_linux_forever == 735)
        #expect(ffXIII.playtime_deck_forever == 735)
        #expect(ffXIII.rtime_last_played == 1719375659)
        
        // Test computed properties
        #expect(ffXIII.totalPlaytimeHours == 123.53333333333333)
        #expect(ffXIII.isRecentlyPlayed == true)
        #expect(ffXIII.primaryPlatform == .windows)
        
        let playtimePercentages = ffXIII.playtimePercentages
        #expect(playtimePercentages[.windows] == 54.16276894293732)
        #expect(playtimePercentages[.mac] == 0)
        #expect(playtimePercentages[.linux] == 22.91861552853134)
        #expect(playtimePercentages[.steamDeck] == 22.91861552853134)
        
        // Note: We can't test exact string for lastPlayedAgo as it depends on the current date
        // Instead, we can check that it's not empty
        #expect(!ffXIII.lastPlayedAgo.isEmpty)
        
        // Test content descriptors if available in the test data
        if let contentDescriptors = ffXIII.content_descriptorids {
            #expect(!contentDescriptors.isEmpty)
            #expect(ffXIII.hasMatureContent == contentDescriptors.contains(.frequentViolenceOrGore))
        }
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
        #expect(firstNewsItem.isExternalUrl)
        #expect(firstNewsItem.author == "Jody Macgregor")
        #expect(firstNewsItem.contents.starts(with: "<img src=\"https://cdn.mos.cms.futurecdn.net/ePdQwZjBaqzcr82pZKCJwT.jpg\"/>"))
        #expect(firstNewsItem.feedlabel == "PC Gamer")
        #expect(firstNewsItem.date == 1720326072)
        #expect(firstNewsItem.feedname == "PC Gamer")
        
        // Test new properties and computed properties
        #expect(firstNewsItem.feedType == .unknown) // Assuming the feed_type in the test data is 0
        #expect(firstNewsItem.publicationDate == Date(timeIntervalSince1970: 1720326072))
        
        // Test plainTextContents
        #expect(!firstNewsItem.plainTextContents.contains("<"))
        #expect(!firstNewsItem.plainTextContents.contains(">"))
        
        // Test shortDescription
        #expect(firstNewsItem.shortDescription.count <= 103) // 100 characters + potential "..."
        
        // Test hasTags
        if let tags = firstNewsItem.tags {
            #expect(firstNewsItem.hasTags == !tags.isEmpty)
        } else {
            #expect(firstNewsItem.hasTags == false)
        }
        
        // Note: We can't test exact string for publishedAgo as it depends on the current date
        // Instead, we can check that it's not empty
        #expect(!firstNewsItem.publishedAgo.isEmpty)
    }
    
    private func decodeJSON<T: Decodable>(_ type: T.Type, from filename: String) throws -> T {
        let url = try #require(Bundle.module.url(forResource: filename, withExtension: "json"))
        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: jsonData)
    }
}
