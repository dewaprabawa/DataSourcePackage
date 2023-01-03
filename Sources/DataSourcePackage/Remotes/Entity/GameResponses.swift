//
//  CategoriesResponse.swift
//  plus_ultra
//
//  Created by OS Live Server on 12/11/22.
//

import Foundation

public struct GameResponses: Codable, Hashable, Equatable {
    let count: Int? = 0
    let next, previous: String?
    let results: [GameResponse]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next, previous
        case results
    }
    
}

public struct GameResponse: Codable, Hashable, Equatable {

    public let id: Int
    public var description: String?
    public let slug, name, released: String?
    public let backgroundImage: String?
    public  let rating : Double?
    public var videoTriler: VideoTriler?
    public  let ratingsCount: Double?
    public var ratingTop: Int?
    public  let updated: String?
    public let genres: [Genre]?
    public let screenShoot: [ShortScreenshoot]?
    public let platforms: [Platforms]?
    public let tags: [Tag]?
    public let playtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, slug, name, released
        case description = "description_raw"
        case backgroundImage = "background_image"
        case videoTriler
        case ratingTop
        case ratingsCount
        case rating
        case updated
        case screenShoot = "short_screenshots"
        case genres
        case tags
        case platforms
        case playtime
    }

}

public struct VideoObject: Codable, Hashable, Equatable {
    public let video480: String?
    public let max: String?
    
    enum CodingKeys: String, CodingKey {
        case video480 = "480"
        case max = "max"
    }
}

public struct VideoTriler: Codable, Hashable, Equatable {
    public  let video: VideoObject?
    public  let preview: String?
    enum CodingKeys: String, CodingKey {
        case video = "data"
        case preview = "preview"
    }
}

public struct Genre: Codable, Hashable, Equatable {
    public let name: String
    public let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageBackground = "image_background"
    }
}

public struct ShortScreenshoot: Codable, Equatable, Hashable {
    
    public  let image: String
    
    enum Codingkeys: String, CodingKey {
        case image
    }
}

public struct Platforms: Codable, Equatable, Hashable {
    public let platform : PlatformValue
    
    enum CodingKeys: String, CodingKey {
        case platform
    }
}

public struct PlatformValue: Codable, Equatable, Hashable  {
    public  let name: String
    public let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageBackground = "image_background"
    }
}

public struct Tag: Codable, Equatable, Hashable {
    public let name: String
    public let imageBackground: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageBackground = "image_background"
    }
}
