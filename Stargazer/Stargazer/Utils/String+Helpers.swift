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

extension String {
  var nonEmptyParts: [String] {
    let parts = components(separatedBy: " ")
    let nonEmpty = parts.filter { !$0.isEmpty }
    return nonEmpty
  }

  var initialStrings: [String] {
    let nonEmpty = nonEmptyParts
    let initis = nonEmpty.map { String($0.first ?? Character("")) }
    let nonEmptyInits = initis.filter { !$0.isEmpty }
    return nonEmptyInits
  }

  func initials(_ num: Int) -> String {
    let strings = initialStrings.map { $0.uppercased() }
    var result = ""; var counter = 0
    for str in strings {
      if counter >= num  { break }
      counter += 1
      result = result + str
    }
    return result

  }

}
