//
//  UITableView+Cell.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

extension UITableView {

  func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
    register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
  }

  func registerCellNib<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
    register(UINib(nibName:String(describing: cellClass) , bundle: nil), forCellReuseIdentifier: String(describing: cellClass))
  }
}
