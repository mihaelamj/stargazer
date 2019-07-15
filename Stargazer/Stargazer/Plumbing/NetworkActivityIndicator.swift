//
//  NetworkActivityIndicator.swift
//  Stargazer
//
//  Created by Mihaela MJ on 16/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

class NetworkActivityIndicator {
  var count = 0
  let queue = DispatchQueue(label: "com.stargazer.networkactivity", qos: .background)
  static let shared = NetworkActivityIndicator()

  private init() { }

  func push() {
    queue.async {
      self.count += 1
      self.updateActivityIndicatorStatus()
    }
  }

  func pop() {
    queue.async {
      self.count -= 1
      self.updateActivityIndicatorStatus()
    }
  }

  private func updateActivityIndicatorStatus() {
    DispatchQueue.main.async {
      // swiftlint:disable:next empty_count
      UIApplication.shared.isNetworkActivityIndicatorVisible = self.count > 0
    }
  }
}
