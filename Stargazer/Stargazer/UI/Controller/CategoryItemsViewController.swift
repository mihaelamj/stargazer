//
//  CategoryItemsViewController.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class CategoryItemsViewController: BaseViewController {

  // MARK: -
  // MARK: IB Properties -

  @IBOutlet weak var tableView: UITableView!

  // MARK: -
  // MARK: Data -

  private var didLoad = false
  
  var data: [StargazerBaseModel]? {
    didSet {
      reloadData()
    }
  }

  // MARK: -
  // MARK: FW Overrides -

  override func viewDidLoad() {
    super.viewDidLoad()
//    self.title = "STAR WARS API"
    setupTableView()
    didLoad = true
    reloadData()
  }

}

// MARK: -
// MARK: Setup -

private extension CategoryItemsViewController {
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    registerCells()
    tableView.rowHeight = 64.0
    tableView.tableFooterView = UIView()

    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = view.backgroundColor
  }
}

// MARK: -
// MARK: Helper -

private extension CategoryItemsViewController {

  func itemAt(_ index: Int) -> StargazerBaseModel? {
    guard let aData = data else { return nil }
    if aData.count > index { return aData[index] }
    return nil
  }

  func dequeuTableCell(_ aTableView: UITableView, cellForRowAt indexPath: IndexPath) -> CategoryItemsTableViewCell {
    let cell = aTableView.dequeueReusableCell(withIdentifier: CategoryItemsTableViewCell.reuseIndetifier(), for: indexPath) as! CategoryItemsTableViewCell
    return cell
  }

  func registerCells() {
    tableView.registerCellNib(CategoryItemsTableViewCell.self)
  }
}

// MARK: -
// MARK: API -

private extension CategoryItemsViewController {
  func reloadData() {
    if didLoad {
      tableView.reloadData()
    }
  }
}

// MARK: -
// MARK: API -

private extension CategoryItemsViewController {
  
}

// MARK: -
// MARK: UITableViewDataSource -

extension CategoryItemsViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let item = itemAt(indexPath.row) else { return UITableViewCell() }
    let aCell = dequeuTableCell(tableView, cellForRowAt: indexPath)
    let adapter = item.asStargazerCategoryItem()
    aCell.customize(any: adapter)
    return aCell
  }
}

// MARK: -
// MARK: UITableViewDelegate -

extension CategoryItemsViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let item = itemAt(indexPath.section) else { return }
    debugPrint("item: \(item)")
    //To wake up the UI, Apple issue with cells with selectionStyle = .none
    CFRunLoopWakeUp(CFRunLoopGetCurrent())

    let vc2: CategoryItemsViewController? = UIViewController.loadFromStoryboard()
    if let aVC = vc2 {
      debugPrint("v2c: \(aVC)")
      navigationController?.pushViewController(aVC, animated: true)
    }
  }

}
