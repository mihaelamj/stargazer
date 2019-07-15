//
//  BaseTableViewCell.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

extension UITableView {

  //MARK: Cell -

  func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
    register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
  }

  func registerCellNib<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
    register(UINib(nibName:String(describing: cellClass) , bundle: nil), forCellReuseIdentifier: String(describing: cellClass))
  }
}

class BaseTableViewCell: UITableViewCell {

  // MARK: -
  // MARK: Template -

  public func setupViews() {}
  public func cleanViews() {}
  public func customize(any: Any?) {}

  // MARK: -
  // MARK: Public -

  public static func reuseIndetifier() -> String {
    return String(describing: self)
  }

  // MARK: -
  // MARK: FW Overrides -

  override func awakeFromNib() {
    super.awakeFromNib()
    setupViews()
  }

  override public func prepareForReuse() {
    cleanViews()
    super.prepareForReuse()
  }


}
