//
//  NibLoadableView.swift
//  Stargazer
//
//  Created by Mihaela MJ on 16/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit
extension NSObject {
  var theClassName: String {
    return NSStringFromClass(type(of: self))
  }
}

class NibLoadableView: UIView {

  // MARK: -
  // MARK: Template -

  internal var myContentView: UIView {
    preconditionFailure("`myContentView` needs to be overriden by concrete subscasses")
  }

  // MARK: -
  // MARK: Init -

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadNibContent()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    loadNibContent()
  }

  // MARK: -
  // MARK: Load -

  private func loadNibContent() {
    let className = self.theClassName
    let parts = className.components(separatedBy: ".")
    let clearClassName = parts.last ?? ""

    Bundle.main.loadNibNamed(clearClassName, owner: self, options: nil)
    addSubview(myContentView)
    myContentView.frame = self.bounds
  }

}

