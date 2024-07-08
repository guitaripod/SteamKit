import Foundation

/// Represents the response structure for player summaries.
struct PlayerSummariesResponse: Codable {
    /// The response container.
    let response: PlayerSummariesResult
}

/// Represents a summary of a Steam player's profile.
public struct PlayerSummary: Codable {
    /// The Steam ID of the player.
    public let steamid: String

    /// The visibility state of the player's community profile.
    public let communityvisibilitystate: CommunityVisibilityState

    /// The state of the player's profile (set up or not).
    public let profilestate: Int

    /// The player's display name.
    public let personaname: String

    /// The URL of the player's Steam profile.
    public let profileurl: URL

    /// The URL of the player's avatar image (small size).
    public let avatar: URL

    /// The URL of the player's avatar image (medium size).
    public let avatarmedium: URL

    /// The URL of the player's avatar image (full size).
    public let avatarfull: URL

    /// The hash of the player's avatar image (optional).
    public let avatarhash: String?

    /// The last time the player was online (Unix timestamp, optional).
    public let lastlogoff: Int?

    /// The current state of the player's persona.
    public let personastate: PersonaState

    /// The player's real name (optional).
    public let realname: String?

    /// The ID of the player's primary group (optional).
    public let primaryclanid: String?

    /// The time the account was created (Unix timestamp, optional).
    public let timecreated: Int?

    /// Flags indicating various states of the player's persona.
    public let personastateflags: PersonaStateFlags

    /// The player's country code (optional).
    public let loccountrycode: String?

    /// The player's state code (optional).
    public let locstatecode: String?

    /// Represents the visibility state of a player's community profile.
    public enum CommunityVisibilityState: Int, Codable {
        case `private` = 1
        case friendsOnly = 2
        case `public` = 3
        case unknown

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(Int.self)
            self = CommunityVisibilityState(rawValue: rawValue) ?? .unknown
        }
    }

    /// Represents the current state of a player's persona.
    public enum PersonaState: Int, Codable {
        case offline = 0
        case online = 1
        case busy = 2
        case away = 3
        case snooze = 4
        case lookingToTrade = 5
        case lookingToPlay = 6
        case unknown

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(Int.self)
            self = PersonaState(rawValue: rawValue) ?? .unknown
        }
    }

    /// Represents various flags for a player's persona state.
    public struct PersonaStateFlags: OptionSet, Codable {
        public let rawValue: Int

        public static let hasRichPresence = PersonaStateFlags(rawValue: 1 << 0)
        public static let inJoinableGame = PersonaStateFlags(rawValue: 1 << 1)
        public static let golden = PersonaStateFlags(rawValue: 1 << 2)
        public static let remotePlayTogether = PersonaStateFlags(rawValue: 1 << 3)
        public static let clientTypeWeb = PersonaStateFlags(rawValue: 1 << 4)
        public static let clientTypeMobile = PersonaStateFlags(rawValue: 1 << 5)
        public static let clientTypeTenfoot = PersonaStateFlags(rawValue: 1 << 6)
        public static let clientTypeVR = PersonaStateFlags(rawValue: 1 << 7)
        public static let launchTypeGamepad = PersonaStateFlags(rawValue: 1 << 8)

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(Int.self)
            self.init(rawValue: rawValue)
        }
    }

    /// Returns a formatted string of the user's real name (if available) and their persona name.
    public var displayName: String {
        if let realname = realname {
            return "\(realname) (\(personaname))"
        }
        return personaname
    }

    /// Returns a Date object representing when the account was created.
    public var creationDate: Date? {
        guard let timecreated = timecreated else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(timecreated))
    }

    /// Returns a formatted string of the account age
    public var accountAge: String {
        guard let creationDate = creationDate else { return "Unknown" }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: creationDate, to: Date())
        if let years = components.year, let months = components.month {
            return "\(years) years and \(months) months"
        }
        return "Unknown"
    }

    /// Returns a string representing the user's online status.
    public var onlineStatus: String {
        switch personastate {
        case .offline: return "Offline"
        case .online: return "Online"
        case .busy: return "Busy"
        case .away: return "Away"
        case .snooze: return "Snooze"
        case .lookingToTrade: return "Looking to Trade"
        case .lookingToPlay: return "Looking to Play"
        case .unknown: return "Unknown"
        }
    }

    /// Returns the date of last logoff.
    public var lastLogoffDate: Date? {
        guard let lastlogoff = lastlogoff else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(lastlogoff))
    }

    /// Returns a formatted string of time since last logoff.
    public var timeSinceLastLogoff: String {
        guard let lastLogoffDate = lastLogoffDate else { return "Unknown" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: lastLogoffDate, relativeTo: Date())
    }

    /// Returns a boolean indicating if the profile is public.
    public var isProfilePublic: Bool {
        return communityvisibilitystate == .public
    }

    /// Returns a boolean indicating if the user is currently using a VR headset.
    public var isUsingVR: Bool {
        return personastateflags.contains(.clientTypeVR)
    }

    /// Returns a string describing the client type the user is currently using.
    public var currentClientType: String {
        if personastateflags.contains(.clientTypeWeb) { return "Web" }
        if personastateflags.contains(.clientTypeMobile) { return "Mobile" }
        if personastateflags.contains(.clientTypeTenfoot) { return "Big Picture" }
        if personastateflags.contains(.clientTypeVR) { return "VR" }
        return "Desktop"
    }
}

/// Contains the result of a player summaries request.
struct PlayerSummariesResult: Codable {
    /// An array of PlayerSummary objects.
    let players: [PlayerSummary]
}
