import Foundation

/// Represents a news item for a Steam app.
public struct NewsItem: Codable {
    /// The global identifier for the news item.
    public let gid: String

    /// The title of the news item.
    public let title: String

    /// The URL of the news item.
    public let url: URL

    /// Indicates whether the URL is external to Steam.
    public let isExternalUrl: Bool

    /// The author of the news item.
    public let author: String

    /// The contents of the news item, potentially containing HTML.
    public let contents: String

    /// The label of the feed the news item came from.
    public let feedlabel: String

    /// The Unix timestamp of when the news item was published.
    public let date: Int

    /// The name of the feed the news item came from.
    public let feedname: String

    /// The type of feed the news item came from.
    public let feedType: FeedType

    /// The app ID the news item is associated with.
    public let appid: Int

    /// Optional tags associated with the news item.
    public let tags: [String]?

    /// Represents different types of news feeds.
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

/// Represents the response structure for news items.
struct NewsForAppResponse: Codable {
    /// The app news container.
    let appnews: AppNews
}

/// Contains news items for an app.
struct AppNews: Codable {
    /// The app ID associated with the news.
    let appid: Int

    /// An array of NewsItem objects.
    let newsitems: [NewsItem]
}
