//
//  UIView+xib.swift
//  Stargazer
//
//  Created by Mihaela MJ on 16/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

extension UIView {
  static func loadFromNib<T: UIView>(withOwner owner: Any?) -> T? {
    let className = String(describing: self)
    return Bundle.main.loadNibNamed(className, owner: owner, options: nil)?.first as? T
  }

  func testItemDetailHeaderView() {
    let headerView = ItemDetailHeaderView.loadFromNib(withOwner: self)
    guard headerView != nil else { return }
  }
}
