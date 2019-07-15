//
//  StargazerCategories.swift
//  Stargazer
//
//  Created by Mihaela MJ on 14/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

enum StargazerCategory: String, CaseIterable {
  case people
  case films
  case starships
  case vehicles
  case species
  case planets
}

extension StargazerCategory: CustomStringConvertible {
  public var description: String {
    return "\(rawValue)"
  }
}
