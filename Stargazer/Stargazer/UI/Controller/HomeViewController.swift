//
//  HomeViewController.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

  // MARK: -
  // MARK: IB Properties -

  @IBOutlet weak var tableView: UITableView!

  // MARK: -
  // MARK: UI Properties -

  private let cellSpacing: CGFloat = 6.0

  // MARK: -
  // MARK: Data Properties -

  private  var data = StargazerCategory.allCases

  // MARK: -
  // MARK: FW Overrides -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "STAR WARS API"
    setupTableView()
  }
}

// MARK: -
// MARK: Setup -

private extension HomeViewController {

  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    registerCells()
    tableView.rowHeight = 56.0
    tableView.tableFooterView = UIView()
    tableView.separatorColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = view.backgroundColor
  }
}

// MARK: -
// MARK: Helper -

private extension HomeViewController {
  func itemAt(_ index: Int) -> StargazerCategory? {
    if data.count > index { return data[index] }
    return nil
  }

  func dequeuTableCell(_ aTableView: UITableView, cellForRowAt indexPath: IndexPath) -> MainCategoryTableViewCell {
    let cell = aTableView.dequeueReusableCell(withIdentifier: MainCategoryTableViewCell.reuseIndetifier(), for: indexPath) as! MainCategoryTableViewCell
    return cell
  }

  func registerCells() {
    tableView.registerCellNib(MainCategoryTableViewCell.self)
  }
}

// MARK: -
// MARK: API -

private extension HomeViewController {

  func fetchItemsFor(_ category: StargazerCategory) {
    setOperation(inProgress: true)

    category.fetchItems { fetchedItems, error in
      self.setOperation(inProgress: false)
      guard let aItems = fetchedItems else {
        self.errorAlert(message: error?.localizedDescription ?? "Unknown error!")
        return
      }

      let itemsVC: CategoryItemsViewController? = UIViewController.loadFromStoryboard()
      if let aVC = itemsVC {
        self.navigationController?.pushViewController(aVC, animated: true)
        aVC.title = category.title
        aVC.data = aItems
      } else {
        self.errorAlert(message: error?.localizedDescription ?? "Unknown error!")
      }
    }
  }

}

// MARK: -
// MARK: UITableViewDataSource -

extension HomeViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return data.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let item = itemAt(indexPath.section) else { return UITableViewCell() }
    let aCell = dequeuTableCell(tableView, cellForRowAt: indexPath)
    let adapter = item.asStargazerCategory()
    aCell.customize(any: adapter)
    return aCell
  }

}

// MARK: -
// MARK: UITableViewDelegate -

extension HomeViewController: UITableViewDelegate {

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

    fetchItemsFor(item)
  }

}
