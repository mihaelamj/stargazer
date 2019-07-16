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
  // MARK: IB Properties -

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!

  // MARK: -
  // MARK: Template -

  override func setupViews() {
    selectionStyle = .none
  }

  override func customize(any: Any?) {
    guard let data = any as? StargazerObjectModel.PropertyTouple else {
      preconditionFailure("Wrong class passed to function: expecting `StargazerObjectModel.PropertyTouple`!")
    }
    nameLabel.text = data.name
    valueLabel.text = data.value
  }

  override func cleanViews() {
    nameLabel.text = ""
    valueLabel.text = ""
  }
    
}
