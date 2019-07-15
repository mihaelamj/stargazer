//
//  UIViewController+Alert.swift
//  Stargazer
//
//  Created by Mihaela MJ on 16/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

extension UIViewController {

  func alert(message: String, title: String = "", completion: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: completion)
  }

  func errorAlert(message: String) {
    alert(message: message, title: "Error!", completion: nil)
  }
}
