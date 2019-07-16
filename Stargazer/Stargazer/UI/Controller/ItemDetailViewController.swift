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
    tableView.delegate = self
    tableView.dataSource = self
    registerCells()
    tableView.rowHeight = 118.0 //****
    tableView.tableFooterView = UIView()
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .black
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

// MARK: -
// MARK: UITableViewDataSource -

extension ItemDetailViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    guard let aData = data else { return 0 }
    return aData.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let item = itemAt(indexPath.section) else { return UITableViewCell() }
    let aCell = dequeuTableCell(tableView, cellForRowAt: indexPath)
    aCell.customize(any: item)
    return aCell
  }

}

// MARK: -
// MARK: UITableViewDelegate -

extension ItemDetailViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return cellSpacing
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = .clear
    return headerView
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let item = itemAt(indexPath.section) else { return }
    debugPrint("item: \(item)")
    //To wake up the UI, Apple issue with cells with selectionStyle = .none
    CFRunLoopWakeUp(CFRunLoopGetCurrent())
    alert(message: "Item: \(item.name)", title: "Hello", completion: nil)
  }

}
