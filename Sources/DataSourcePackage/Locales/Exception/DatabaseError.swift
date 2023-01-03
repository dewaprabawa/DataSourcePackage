//
//  DatabaseError.swift
//  plus_ultra
//
//  Created by OS Live Server on 17/12/22.
//

import Foundation

public enum DatabaseError: LocalizedError {

  case invalidInstance
  case requestFailed
  
  public var errorDescription: String? {
    switch self {
    case .invalidInstance: return "Database can't instance."
    case .requestFailed: return "Your request failed."
    }
  }

}
