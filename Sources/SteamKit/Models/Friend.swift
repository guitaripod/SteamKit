import Foundation

public struct Friend: Codable {
    public let steamid: String
    public let relationship: String
    public let friend_since: Int
}

struct FriendListResponse: Codable {
    let friendslist: FriendsList
}

struct FriendsList: Codable {
    let friends: [Friend]
}
