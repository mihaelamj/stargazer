//
//  ItemDetailHeaderView.swift
//  Stargazer
//
//  Created by Mihaela MJ on 16/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class ItemDetailHeaderView: NibLoadableView {

  // MARK: -
  // MARK: Template Overrides -

  @IBOutlet var contentView: UIView!
  internal override var myContentView: UIView { return contentView }

  // MARK: -
  // MARK: IB Properties -

  @IBOutlet weak var circleInitials: CircleInitialLabel!
  @IBOutlet weak var subtitleLabel: UILabel!

  // MARK: -
  // MARK: Customize -
  
  public func customize(data: StargazerItemHeaderAdapter) {
    circleInitials.type = .big
    circleInitials.text = data.initials
    subtitleLabel.text = data.subtitle
  }

}
