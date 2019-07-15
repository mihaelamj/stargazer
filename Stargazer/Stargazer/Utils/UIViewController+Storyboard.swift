//
//  UIViewController+Storyboard.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

extension UIViewController {
  static func loadFromStoryboard<Controller: UIViewController>(_ name: String = "Main") -> Controller? {
    let identifier = String(describing: Controller.self)
    let viewController = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: identifier)
    return viewController as? Controller
  }
}
