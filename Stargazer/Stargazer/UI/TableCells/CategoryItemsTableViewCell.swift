//
//  CategoryItemsTableViewCell.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class CategoryItemsTableViewCell: BaseTableViewCell {

  @IBOutlet weak var cicleLabel: CircleInitialLabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var createdLabel: UILabel!
  // MARK: -
  // MARK: Template -

  override func setupViews() {
    selectionStyle = .none
    accessoryType = .none
  }

  override func customize(any: Any?) {
    guard let data = any as? StargazerCategoryItemListAdapter else {
      preconditionFailure("Wrong class passed to function: expecting `SearchResultModel`!")
    }
    cicleLabel.text = data.initials
    nameLabel.text = data.title
    dateLabel.text = data.subtitle
    createdLabel.text = data.dateCreated
  }

  override func cleanViews() {
    cicleLabel.text = ""
    nameLabel.text = ""
    dateLabel.text = ""
    createdLabel.text = ""
  }

}
