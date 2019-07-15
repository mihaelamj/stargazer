//
//  StargazerModelProperties.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

func testProps() {
  let model = StargazerModel(name: "Name", category: .planets, created: Date(), urlString: "https://swapi.co/api/films/1/")

  let mirrored_object = Mirror(reflecting: model)

  for (index, attr) in mirrored_object.children.enumerated() {
    if let propertyName = attr.label as? String {
      var name = "unknown name"
      if let attLable = attr.label { name = attLable}

      var value = attr.value
      if let aDecription = attr.value as? CustomStringConvertible {
        value = aDecription.description
      }
      print("Attr \(index): \(name) = \(value)")
//      print("Attr \(index): \(propertyName) = \(attr.value)")
    }
  }

  let props = model.getAllPropertyValues()
  print("props \(props)")
}

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

  func getAllPropertyValues() -> [PropertyTouple] {
    let mirroredObject = Mirror(reflecting: self)
    var result = [PropertyTouple]()
    for (index, attr) in mirroredObject.children.enumerated() {
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
}

