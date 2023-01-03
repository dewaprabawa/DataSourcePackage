//
//  URLerror.swift
//  plus_ultra
//
//  Created by OS Live Server on 17/12/22.
//

import Foundation


public enum URLError: LocalizedError {

  case invalidResponse
  case addressUnreachable(URL)
  
    public var errorDescription: String? {
    switch self {
    case .invalidResponse: return "The server responded with garbage."
    case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
    }
  }

}
