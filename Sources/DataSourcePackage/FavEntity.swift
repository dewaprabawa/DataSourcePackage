//
//  FavEntity.swift
//  plus_ultra
//
//  Created by OS Live Server on 26/11/22.
//

import Foundation
import RealmSwift



public class FavEntity: Object {
     
    @Persisted public var id: Int = 0
    @Persisted public var gameCreateTime: Double = 0
    @Persisted public var name: String = ""
    @Persisted public var descriptionText: String = ""
    @Persisted public var slug: String = ""
    @Persisted public var released: String = ""
    @Persisted public var rating: Double = 0
    @Persisted public var ratingTop: Int = 0
    @Persisted public var videoUrl: String = ""
    @Persisted public var genre: String = ""
    @Persisted public var platforms: String = ""
    @Persisted public var tags: String = ""
    @Persisted public var playTime: Int = 0
    @Persisted public var backgroundImage: String = ""
    @Persisted public var screenShoots: List<String>
    @Persisted public var ratingsCount: Double = 0
    
    public override class func primaryKey() -> String? {
        return "id"
    }
}
