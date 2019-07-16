//
//  StargazerItemHeaderAdapter.swift
//  Stargazer
//
//  Created by Mihaela MJ on 16/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

// MARK: -
// MARK: Model Adapter -

struct StargazerItemHeaderAdapter {
  var initials: String?
  var subtitle: String?

  init(initials: String,subtitle: String) {
    self.initials = initials
    self.subtitle = subtitle
  }
}

protocol StargazerItemHeaderAdapterProtocol {
  func asStargazerItemHeaderAdapter() -> StargazerItemHeaderAdapter
}
