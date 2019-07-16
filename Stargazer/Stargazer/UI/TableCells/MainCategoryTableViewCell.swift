//
//  MainCategoryTableViewCell.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class MainCategoryTableViewCell: BaseTableViewCell {

  // MARK: -
  // MARK: IB Properties -

  @IBOutlet weak var catImage: UIImageView!
  @IBOutlet weak var label: UILabel!

  // MARK: -
  // MARK: Properties -

  private let edge: CGFloat = 4.0

  // MARK: -
  // MARK: Template -

  override func setupViews() {
    selectionStyle = .none
  }

  override func customize(any: Any?) {
    guard let data = any as? StargazerCategoryAdapter else {
      preconditionFailure("Wrong class passed to function: expecting `StargazerCategoryAdapter`!")
    }
    catImage.image = data.image
    label.text = data.title
  }

  override func cleanViews() {
    catImage.image = nil
    label.text = ""
  }

}

// MARK: -
// MARK: FW Overrides -

extension MainCategoryTableViewCell {
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = edge
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    layer.shadowRadius = 1.0
    layer.shadowOpacity = 0.9
    layer.borderColor = UIColor.lightGray.cgColor
    layer.borderWidth = 0.5

    layer.masksToBounds = false
    clipsToBounds = false
  }
}
