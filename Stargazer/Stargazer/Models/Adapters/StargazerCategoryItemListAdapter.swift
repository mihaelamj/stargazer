//
//  StargazerCategoryItem.swift
//  Stargazer
//
//  Created by Mihaela MJ on 14/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

// MARK: -
// MARK: Model Adapter -

struct StargazerCategoryItemListAdapter {
  var initials: String?
  var title: String?
  var subtitle: String?
  var dateCreated: String?
  var category: StargazerCategory?
  var id: Int?

  init(initials: String, title: String, subtitle: String, dateCreated: String, category: StargazerCategory, id: Int?) {
    self.initials = initials
    self.title = title
    self.subtitle = subtitle
    self.dateCreated = dateCreated
    self.category = category
    self.id = id
  }
}

protocol StargazerCategoryItemListAdapterProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter
}
