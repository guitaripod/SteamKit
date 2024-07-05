import Foundation
import ArgumentParser
import SteamKit

@main
struct SteamKitCLI: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "steamkit",
        abstract: "A CLI for interacting with the Steam API",
        subcommands: [PlayerSummary.self, OwnedGames.self, RecentGames.self]
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
