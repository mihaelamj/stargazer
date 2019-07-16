//
//  StargazerModelProperties.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

extension String {
  static func from(any: Any) -> String {
    if let aString = any as? String {
      return aString
    } else if let aInt = any as? Int {
      return "\(aInt)"
    } else if let aUint = any as? UInt {
      return "\(aUint)"
    } else if let aBool = any as? Bool {
      return "\(aBool)"
    } else if let aDouble = any as? Double {
      return "\(aDouble)"
    } else if let aDate = any as? Date {
      return "\(aDate)"
    } else if let aUrlStringItem = any as? UrlStringItem {
      return "\(aUrlStringItem)"
    } else if let aUrlStringItems = any as? UrlStringItems {
      return "\(aUrlStringItems)"
    } else if let aCSVStringItems = any as? CSVStringItems {
      return "\(aCSVStringItems)"
    } else if let aStargazerPersonColorType = any as? StargazerPersonColorType {
      return "\(aStargazerPersonColorType)"
    } else if let aStargazerPersonColor = any as? StargazerPersonColor {
      return "\(aStargazerPersonColor)"
    } else if let aStargazerGender = any as? StargazerGender {
      return "\(aStargazerGender)"
    } else if let aStargazerCategory = any as? StargazerCategory {
      return "\(aStargazerCategory)"
    }
    return "\(any)"
  }
}

extension StargazerObjectModel {
  typealias PropertyTouple = (name: String, value: String, index: Int)

  func processMirrorObject(_ mirror: Mirror) -> [PropertyTouple] {
    var result = [PropertyTouple]()
    for (index, attr) in mirror.children.enumerated() {
      if let name = attr.label {
        if let aVessel = attr.value as? StargazerVessel {
          let vesselProperties = aVessel.getAllPropertyValues()
          result.append(contentsOf: vesselProperties)
        } else {
          let value = String.from(any: attr.value)
          let newItem = (name: name, value: value, index: index)
          result.append(newItem)
        }
      }
    }
    return result
  }

  func getAllPropertyValues() -> [PropertyTouple] {
    var mirror: Mirror? = Mirror(reflecting: self)
    var result = [PropertyTouple]()

    repeat {
      if let aMirror = mirror {
        let props = processMirrorObject(aMirror)
        result.append(contentsOf: props)
        mirror = aMirror.superclassMirror
      }
    } while mirror != nil

    return result
  }
}


