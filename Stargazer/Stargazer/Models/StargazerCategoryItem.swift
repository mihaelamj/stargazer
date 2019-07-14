//
//  StargazerCategoryItem.swift
//  Stargazer
//
//  Created by Mihaela MJ on 14/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

class StargazerCategoryItem {
  var initials: String?
  var title: String?
  var subtitle: String?
  var dateCreated: String?
  var category: StargazerCategory?
}

protocol StargazerCategoryItemProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItem
}
