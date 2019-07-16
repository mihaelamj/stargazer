//
//  BaseViewController.swift
//  Stargazer
//
//  Created by Mihaela MJ on 16/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

  // MARK: -
  // MARK: Internal

  private lazy var activityIndicator: UIActivityIndicatorView = {
    let act = UIActivityIndicatorView(style: .white)
    act.translatesAutoresizingMaskIntoConstraints = false
    return act
  }()

  // MARK: -
  // MARK: View Lifecycle -

  override public func viewDidLoad() {
    super.viewDidLoad()
    setupActivityIndicator()
    navigationController?.navigationBar.tintColor = .white
  }

}

// MARK: -
// MARK: Public Actions -

extension BaseViewController {

  func setOperation(inProgress: Bool) {
    if inProgress {
      NetworkActivityIndicator.shared.push()
      activityIndicator.startAnimating()
    } else {
      NetworkActivityIndicator.shared.pop()
      activityIndicator.stopAnimating()
    }
  }

}

// MARK: -
// MARK: Setup -

private extension BaseViewController {

  func setupActivityIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = .whiteLarge
    activityIndicator.color = .red
    let name = "activity"
    let centerX = activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor); centerX.identifier = "\(name)_centerX"; centerX.isActive = true
    let centerY = activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor); centerY.identifier = "\(name)_centerY"; centerY.isActive = true
  }
  
}
