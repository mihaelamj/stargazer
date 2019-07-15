//
//  StargazerCategoryAdapter.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

// MARK: -
// MARK: Model Adapter -

struct StargazerCategoryAdapter {
  var image: UIImage?
  var title: String?
  var category: StargazerCategory?

  init(image: UIImage, title: String, category: StargazerCategory) {
    self.image = image
    self.title = title
    self.category = category
  }
}

protocol StargazerCategoryAdapterdapterProtocol {
  func asStargazerCategory() -> StargazerCategoryAdapter
}

// MARK: -
// MARK: Adapters -

extension StargazerCategory: StargazerCategoryAdapterdapterProtocol {
  func asStargazerCategory() -> StargazerCategoryAdapter {
    return StargazerCategoryAdapter(image: asImage(), title: title , category: self)
  }
}
