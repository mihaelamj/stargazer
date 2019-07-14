//
//  StargazerImages.swift
//  Stargazer
//
//  Created by Mihaela MJ on 14/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

// MARK: -
// MARK: Protocol -

protocol StargazerIconImageProtocol {
  static func namespace() -> String
  func asImage() -> UIImage
  var imageName: String { get }
}

// MARK: -
// MARK: Namespaces -

enum ImageNamespaces: String, CaseIterable {
  case categories
  case misc
  case root
}

// MARK: -
// MARK: Enums -

extension StargazerCategory: StargazerIconImageProtocol {

  var imageName: String {
    switch self {
    case .people:
      return "noun_person_1880095"
    case .films:
      return "noun_Film_1666495"
    case .starships:
      return "noun_spaceship_1311585"
    case .vehicles:
      return "noun_Car_1881053"
    case .species:
      return "noun_alien_627223"
    case .planets:
      return "noun_Planet_1867071"
    }
  }
  
  static func namespace() -> String {
    return "\(ImageNamespaces.categories.rawValue)/"
  }
  func asImage() -> UIImage {
    // swiftlint:disable:next force_unwrapping
    return UIImage(named: StargazerCategory.namespace() + imageName)!
  }
}

enum StargazerRootImage: String, CaseIterable, StargazerIconImageProtocol  {
  static func namespace() -> String {
    return "\(ImageNamespaces.root.rawValue)/"
  }

  func asImage() -> UIImage {
    // swiftlint:disable:next force_unwrapping
    return UIImage(named: StargazerRootImage.namespace() + imageName)!
  }

  case header
  case headerGradient
  case ensign

  var imageName: String {
    switch self {
    case .header:
      return "application_root_header"
    case .headerGradient:
      return "application_root_header_gradient"
    case .ensign:
      return "ensigns"
    }
  }
}

enum StargazerMiscImage: String, CaseIterable, StargazerIconImageProtocol {
  static func namespace() -> String {
    return "\(ImageNamespaces.misc.rawValue)/"
  }

  func asImage() -> UIImage {
    // swiftlint:disable:next force_unwrapping
    return UIImage(named: StargazerMiscImage.namespace() + imageName)!
  }

  case disclosure

  var imageName: String {
    switch self {
    case .disclosure:
      return "disclosure_caret"
    }
  }
}

// MARK: -
// MARK: All Images -

struct StargazerImages {
  var categories: [StargazerCategory] = StargazerCategory.allCases
  var root: [StargazerRootImage] = StargazerRootImage.allCases
  var misc: [StargazerMiscImage] = StargazerMiscImage.allCases
}
