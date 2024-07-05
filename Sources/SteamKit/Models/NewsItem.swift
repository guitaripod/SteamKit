import Foundation

public struct NewsItem: Codable {
    public let gid: String
    public let title: String
    public let url: String
    public let is_external_url: Bool
    public let author: String
    public let contents: String
    public let feedlabel: String
    public let date: Int
    public let feedname: String
}

struct NewsForAppResponse: Codable {
    let appnews: AppNews
}

struct AppNews: Codable {
    let appid: Int
    let newsitems: [NewsItem]
}
