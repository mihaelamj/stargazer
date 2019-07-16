//
//  ItemDetailViewController.swift
//  Stargazer
//
//  Created by Mihaela MJ on 16/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class ItemDetailViewController: BaseViewController {

  // MARK: -
  // MARK: IB Properties -

  @IBOutlet weak var tableView: UITableView!

  // MARK: -
  // MARK: UI Properties -

  private let cellSpacing: CGFloat = 32.0

  // MARK: -
  // MARK: Data -

  private var didLoad = false

  var modelItem: StargazerBaseModel? {
    didSet {
      reloadData()
    }
  }

  var data: [StargazerObjectModel.PropertyTouple]?

  // MARK: -
  // MARK: FW Overrides -

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    didLoad = true
    reloadData()
  }
}

// MARK: -
// MARK: Setup -

private extension ItemDetailViewController {
  func setupTableView() {
//    tableView.delegate = self
//    tableView.dataSource = self
    registerCells()
    tableView.rowHeight = 118.0 //****
    tableView.tableFooterView = UIView()
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = view.backgroundColor
  }
}

// MARK: -
// MARK: Helper -

private extension ItemDetailViewController {

  func itemAt(_ index: Int) -> StargazerObjectModel.PropertyTouple? {
    guard let aData = data else { return nil }
    if aData.count > index { return aData[index] }
    return nil
  }

  func dequeuTableCell(_ aTableView: UITableView, cellForRowAt indexPath: IndexPath) -> CategoryItemDetailTableViewCell {
    let cell = aTableView.dequeueReusableCell(withIdentifier: CategoryItemDetailTableViewCell.reuseIndetifier(), for: indexPath) as! CategoryItemDetailTableViewCell
    return cell
  }

  func registerCells() {
    tableView.registerCellNib(CategoryItemDetailTableViewCell.self)
  }
}

// MARK: -
// MARK: Data -

private extension ItemDetailViewController {
  func reloadData() {
    if didLoad {
      if let aItem = modelItem {
        data = aItem.getAllPropertyValues()
      }
      tableView.reloadData()
    }
  }
}
