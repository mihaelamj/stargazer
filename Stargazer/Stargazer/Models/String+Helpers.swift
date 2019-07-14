//
//  String+Helpers.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

extension String {

  func withoutSpaces() -> String {
    return trimmingCharacters(in: .whitespaces)
  }
  func withoutSpacesAndNewlines() -> String {
    return trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var containsSpaces : Bool {
    return(self.rangeOfCharacter(from: .whitespaces) != nil)
  }
  var containsSpacesOrNewLines : Bool {
    return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
  }
}

extension String {
  var caseless: String {
    return trimmingCharacters(in: .whitespaces).lowercased()
  }
}
