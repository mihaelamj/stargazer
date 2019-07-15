//
//  CategoryItemDetailTableViewCell.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class CategoryItemDetailTableViewCell: BaseTableViewCell {

  // MARK: -
  // MARK: Template -

  override func setupViews() {
    selectionStyle = .none
  }

  override func customize(any: Any?) {
    guard let data = any as? StargazerCategoryItemListAdapter else {
      preconditionFailure("Wrong class passed to function: expecting `SearchResultModel`!")
    }
  }

  override func cleanViews() {
  }
    
}
