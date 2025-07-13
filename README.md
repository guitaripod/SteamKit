# SteamKit

[![wakatime](https://wakatime.com/badge/user/52d828f5-807b-496a-bfc0-5dbef43c05e5/project/4db0c91f-a68b-466f-84dd-6392013b5654.svg)](https://wakatime.com/badge/user/52d828f5-807b-496a-bfc0-5dbef43c05e5/project/4db0c91f-a68b-466f-84dd-6392013b5654)

SteamKit is a Swift package that provides a convenient wrapper around the Steam Web API. I created this package to make it easier for iOS, macOS, tvOS, and watchOS developers to integrate Steam functionality into their apps.

### [DocC Documentation](https://marcusziade.github.io/SteamKit/documentation/steamkit/)


## Features

- Asynchronous API using Swift's modern concurrency model
- Comprehensive coverage of Steam Web API endpoints
- Type-safe responses with Codable models
- Easy to use and integrate into existing projects

## Requirements

- Swift 5.9
- iOS 17.0+
- macOS 14.0+
- tvOS 17.0+
- watchOS 8.0+

## Installation

### Swift Package Manager

To integrate SteamKit into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/marcusziade/SteamKit.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

First, import SteamKit in your Swift file:

```swift
import SteamKit
```

Then, create an instance of `SteamAPI` with your Steam Web API key:

```swift
let steamAPI = SteamAPI(apiKey: "YOUR_STEAM_API_KEY")
```

Now you can use the various methods provided by `SteamAPI`. For example, to get player summaries:

```swift
do {
    let playerSummaries = try await steamAPI.getPlayerSummaries(steamIDs: ["76561197960435530"])
    print(playerSummaries)
} catch {
    print("Error: \(error)")
}
```

## Available Methods

- `getPlayerSummaries(steamIDs:)`
  - Retrieves player summaries for the given Steam IDs
  - Parameter: `steamIDs` - An array of Steam ID strings
- `getFriendList(steamID:)`
  - Retrieves the friend list for a given Steam ID
  - Parameter: `steamID` - A Steam ID string
- `getOwnedGames(steamID:)`
  - Retrieves the list of owned games for a given Steam ID
  - Parameter: `steamID` - A Steam ID string
- `getPlayerAchievements(steamID:appID:)`
  - Retrieves the achievements for a player in a specific game
  - Parameters: `steamID` - A Steam ID string, `appID` - The app ID of the game
- `getNewsForApp(steamID:appID:)`
  - Retrieves news articles for a specific app
  - Parameters: `steamID` - A Steam ID string, `appID` - The app ID of the game
- `getGlobalAchievementPercentagesForApp(gameID:)`
  - Retrieves the global achievement percentages for a specific game
  - Parameter: `gameID` - The game ID to get achievement percentages for
- `getRecentlyPlayedGames(steamID:count:)`
  - Retrieves the list of recently played games for a given Steam ID
  - Parameters: `steamID` - A Steam ID string, `count` - Optional number of games to return
- `getUserStatsForGame(steamID:appID:)`
  - Retrieves a player's stats for a specific game
  - Parameters: `steamID` - A Steam ID string, `appID` - The app ID of the game
- `getSchemaForGame(appID:)`
  - Retrieves the schema for a specific game
  - Parameter: `appID` - The app ID of the game
- `getPlayerBans(steamIDs:)`
  - Retrieves the ban statuses for given Steam IDs
  - Parameter: `steamIDs` - An array of Steam ID strings

## Error Handling

SteamKit uses a custom `SteamKitError` enum for error handling. Be sure to catch and handle these errors appropriately in your code.

## Contributing

I welcome contributions to SteamKit. If you have a feature request, bug report, or want to contribute code, please open an issue or submit a pull request.

## License

SteamKit is available under the MIT license. See the LICENSE file for more info.
