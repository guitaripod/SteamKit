import Foundation

/// Represents a friend in a user's Steam friend list.
public struct Friend: Codable {
    /// The Steam ID of the friend.
    public let steamid: String

    /// The relationship status with the friend.
    public let relationship: String

    /// The Unix timestamp when the friendship was established.
    public let friend_since: Int
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
