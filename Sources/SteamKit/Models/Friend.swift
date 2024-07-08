import Foundation

/// Represents a friend in a user's Steam friend list.
public struct Friend: Codable {
    /// The Steam ID of the friend.
    public let steamid: String
    
    /// The relationship status with the friend.
    public let relationship: String
    
    /// The Unix timestamp when the friendship was established.
    public let friend_since: Int
    
    /// Returns the date when the friendship was established.
    public var friendshipDate: Date {
        Date(timeIntervalSince1970: TimeInterval(friend_since))
    }
    
    /// Returns a formatted string of how long the friendship has lasted.
    public var friendshipDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day]
        formatter.unitsStyle = .full
        return formatter.string(from: friendshipDate, to: Date()) ?? "Unknown"
    }
    
    /// Returns true if the relationship is "friend".
    public var isFriend: Bool {
        relationship.lowercased() == "friend"
    }
    
    /// Returns a URL to the friend's Steam profile.
    public var profileURL: URL {
        URL(string: "https://steamcommunity.com/profiles/\(steamid)")!
    }
}

/// Represents the response structure for a friend list request.
struct FriendListResponse: Codable {
    /// The friend list container.
    let friendslist: FriendsList
}

/// Contains the list of friends.
struct FriendsList: Codable {
    /// An array of Friend objects.
    let friends: [Friend]
}
