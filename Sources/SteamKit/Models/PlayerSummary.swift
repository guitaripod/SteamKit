import Foundation

public struct PlayerSummary: Codable {
    public let steamid: String
    public let communityvisibilitystate: CommunityVisibilityState
    public let profilestate: Int
    public let personaname: String
    public let profileurl: URL
    public let avatar: URL
    public let avatarmedium: URL
    public let avatarfull: URL
    public let avatarhash: String?
    public let lastlogoff: Int?
    public let personastate: PersonaState
    public let realname: String?
    public let primaryclanid: String?
    public let timecreated: Int?
    public let personastateflags: PersonaStateFlags
    public let loccountrycode: String?
    public let locstatecode: String?
    
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

struct PlayerSummariesResponse: Codable {
    let response: PlayerSummariesResult
}

struct PlayerSummariesResult: Codable {
    let players: [PlayerSummary]
}
