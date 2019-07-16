//
//  ItemDetailHeaderView.swift
//  Stargazer
//
//  Created by Mihaela MJ on 16/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class ItemDetailHeaderView: UIView {

  @IBOutlet weak var circleInitials: CircleInitialLabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  
  public func customize(propertyTouple: StargazerObjectModel.PropertyTouple) {
    circleInitials.text = propertyTouple.name.initials(2)
    subtitleLabel.text = propertyTouple.value
  }

}
