import ArgumentParser
import Foundation
import SteamKit

@main
struct SteamKitCLI: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "steamkit",
        abstract: "A CLI for interacting with the Steam API",
        subcommands: [
            PlayerSummary.self,
            OwnedGames.self,
            RecentGames.self,
            FriendList.self,
            PlayerAchievements.self,
            NewsForApp.self,
            GlobalAchievements.self,
            UserStats.self,
            GameSchema.self,
            PlayerBans.self,
        ]
    )
}

struct PlayerSummary: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "summary")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(help: "Steam ID")
    var steamID: String

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let summaries = try await api.getPlayerSummaries(steamIDs: [steamID])
        if let summary = summaries.first {
            print("Player name: \(summary.personaname)")
            print("Profile URL: \(summary.profileurl)")
        } else {
            print("No player summary found")
        }
    }
}

struct OwnedGames: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "owned-games")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(help: "Steam ID")
    var steamID: String

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let games = try await api.getOwnedGames(steamID: steamID)
        print("Owned games: \(games.count)")
        for game in games.prefix(5) {
            print("- \(game.name ?? "Unknown game") (Playtime: \(game.playtime_forever) minutes)")
        }
    }
}

struct RecentGames: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "recent-games")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(help: "Steam ID")
    var steamID: String

    @Option(name: .shortAndLong, help: "Number of recent games to display")
    var count: Int = 5

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let games = try await api.getRecentlyPlayedGames(steamID: steamID, count: count)
        print("Recently played games:")
        for game in games {
            print("- \(game.name) (Playtime in last 2 weeks: \(game.playtime_2weeks) minutes)")
        }
    }
}

struct FriendList: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "friends")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(help: "Steam ID")
    var steamID: String

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let friends = try await api.getFriendList(steamID: steamID)
        print("Total friends: \(friends.count)")
        for friend in friends.prefix(10) {
            print("Friend ID: \(friend.steamid)")
            print("Relationship: \(friend.relationship)")
            print("Friends since: \(friend.friendshipDuration)")
            print("Profile URL: \(friend.profileURL)")
            print("---")
        }
    }
}

struct PlayerAchievements: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "achievements")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(help: "Steam ID")
    var steamID: String

    @Argument(help: "App ID")
    var appID: Int

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let achievements = try await api.getPlayerAchievements(steamID: steamID, appID: appID)
        print("Total achievements: \(achievements.count)")
        for achievement in achievements {
            print("Name: \(achievement.apiname)")
            print("Status: \(achievement.status)")
            print("---")
        }
    }
}

struct NewsForApp: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "news")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(help: "Steam ID")
    var steamID: String

    @Argument(help: "App ID")
    var appID: Int

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let newsItems = try await api.getNewsForApp(steamID: steamID, appID: appID)
        print("Total news items: \(newsItems.count)")
        for item in newsItems.prefix(5) {
            print("Title: \(item.title)")
            print("URL: \(item.url)")
            print("Published: \(item.publishedAgo)")
            print("Short description: \(item.shortDescription)")
            print("---")
        }
    }
}

struct GlobalAchievements: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "global-achievements")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(help: "Game ID")
    var gameID: Int

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let achievements = try await api.getGlobalAchievementPercentagesForApp(gameID: gameID)
        print("Total global achievements: \(achievements.count)")
        for achievement in achievements.prefix(10) {
            print("Name: \(achievement.name)")
            print("Percentage: \(achievement.formattedPercentage)")
            print("Rarity: \(achievement.rarity)")
            print("---")
        }
    }
}

struct UserStats: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "user-stats")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(help: "Steam ID")
    var steamID: String

    @Argument(help: "App ID")
    var appID: Int

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let stats = try await api.getUserStatsForGame(steamID: steamID, appID: appID)
        print("Game: \(stats.gameName)")
        print("Total stats: \(stats.totalStats)")
        print("Total achievements: \(stats.totalAchievements)")
        print("Unlocked achievements: \(stats.unlockedAchievements)")
        print("Achievement completion: \(String(format: "%.2f%%", stats.achievementCompletionPercentage))")
        print("\nTop 5 stats:")
        for stat in stats.statsSortedByValue.prefix(5) {
            print("\(stat.name): \(stat.value)")
        }
    }
}

struct GameSchema: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "game-schema")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(help: "App ID")
    var appID: Int

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let schema = try await api.getSchemaForGame(appID: appID)
        print("Game: \(schema.gameName)")
        print("Version: \(schema.gameVersion)")
        print("Total stats: \(schema.totalStats)")
        print("Total achievements: \(schema.totalAchievements)")
        print("Hidden achievements: \(schema.hiddenAchievements)")

        print("\nFirst 5 stats:")
        for stat in schema.availableGameStats.stats.prefix(5) {
            print("Name: \(stat.name)")
            print("Default value: \(stat.defaultvalue)")
            print("Display name: \(stat.displayName)")
            print("---")
        }

        print("\nFirst 5 achievements:")
        for achievement in schema.availableGameStats.achievements.prefix(5) {
            print("Name: \(achievement.name)")
            print("Display name: \(achievement.displayName)")
            print("Description: \(achievement.description)")
            print("Hidden: \(achievement.isHidden ? "Yes" : "No")")
            print("---")
        }
    }
}

struct PlayerBans: AsyncParsableCommand {
    static var configuration = CommandConfiguration(commandName: "player-bans")

    @Argument(help: "Steam API Key")
    var apiKey: String

    @Argument(parsing: .remaining, help: "Steam IDs")
    var steamIDs: [String]

    func run() async throws {
        let api = SteamAPI(apiKey: apiKey)
        let bans = try await api.getPlayerBans(steamIDs: steamIDs)
        for ban in bans {
            print("Player: \(ban.SteamId)")
            print("Community banned: \(ban.CommunityBanned ? "Yes" : "No")")
            print("VAC banned: \(ban.VACBanned ? "Yes" : "No")")
            print("Number of VAC bans: \(ban.NumberOfVACBans)")
            print("Days since last ban: \(ban.DaysSinceLastBan)")
            print("Number of game bans: \(ban.NumberOfGameBans)")
            print("Economy ban: \(ban.EconomyBan)")
            print("Ban summary: \(ban.banSummary)")
            print("Ban severity: \(ban.banSeverity.rawValue)")
            if let lastBanDate = ban.lastBanDate {
                print("Last ban date: \(lastBanDate)")
            }
            print("---")
        }
    }
}
