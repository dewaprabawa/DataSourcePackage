//
//  UrlHelper.swift
//  plus_ultra
//
//  Created by OS Live Server on 15/11/22.
//

import Foundation

struct API {

  static let baseUrl = "https://api.rawg.io/api"
    
  static var parameters: [String : String] = [
        "key" : "06adc94cb320408cba70f58445aacc24",
    ]

}

protocol Endpoint {
    
  var url: String { get }

}

enum Endpoints {
    
  enum Genre:String, CaseIterable {
      case action = "action"
      case indie = "indie"
      case adventure = "adventure"
      case rpg = "rpg"
      case strategy = "strategy"
      case shooter = "shooter"
      case casual = "casual"
      case simulation = "simulation"
      case puzzle = "puzzle"
      case arcade = "arcade"
      case platformer = "platformer"
  }
  
  enum Gets: Endpoint {
    case games
    case genres(Genre)
    case gameDetail(Int)
    case gameTrailer(Int)
    case search(String)
    
    public var url: String {
      switch self {
      case .genres(let genre):
          return "\(API.baseUrl)/games?genres=\(genre.rawValue)"
      case .games: return "\(API.baseUrl)/games"
      case .gameDetail(let id): return "\(API.baseUrl)/games/\(id.description)"
      case .gameTrailer(let id): return "\(API.baseUrl)/games/\(id.description)/movies"
      case .search(let query): return "\(API.baseUrl)/games?search=\(query)"
      }
    }
  }
  
}
