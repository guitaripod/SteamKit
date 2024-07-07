import Foundation

public struct NewsItem: Codable {
    public let gid: String
    public let title: String
    public let url: URL
    public let isExternalUrl: Bool
    public let author: String
    public let contents: String
    public let feedlabel: String
    public let date: Int
    public let feedname: String
    public let feedType: FeedType
    public let appid: Int
    public let tags: [String]?
    
    public enum FeedType: Int, Codable {
        case unknown = 0
        case steamNews = 1
        case steamForumTopic = 2
        // Add more cases as needed
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(Int.self)
            self = FeedType(rawValue: rawValue) ?? .unknown
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case gid, title, url, author, contents, feedlabel, date, feedname, appid, tags
        case isExternalUrl = "is_external_url"
        case feedType = "feed_type"
    }
    
    /// Returns the publication date as a Date object
    public var publicationDate: Date {
        Date(timeIntervalSince1970: TimeInterval(date))
    }
    
    /// Returns a formatted string of how long ago the news was published
    public var publishedAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: publicationDate, relativeTo: Date())
    }
    
    /// Returns the content without HTML tags
    public var plainTextContents: String {
        contents.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    /// Returns a truncated version of the content (first 100 characters)
    public var shortDescription: String {
        let truncated = plainTextContents.prefix(100)
        return truncated.count < plainTextContents.count ? String(truncated) + "..." : String(truncated)
    }
    
    /// Returns true if the news item has any tags
    public var hasTags: Bool {
        return tags?.isEmpty == false
    }
}

struct NewsForAppResponse: Codable {
    let appnews: AppNews
}

struct AppNews: Codable {
    let appid: Int
    let newsitems: [NewsItem]
}
