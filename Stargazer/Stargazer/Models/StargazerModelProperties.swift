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

func testAPIPeople() {

  StargazerCategory.fetchPeople { items, error in
    if let aItems = items {
      if let aItem = aItems.first {
        let props = aItem.getAllPropertyValues()
        debugPrint("props: \(props)")
      }
    }
    if let aError = error {
      debugPrint("error: \(aError)")
    }
  }
}

func testAPIVehciles() {

  StargazerCategory.fetchVehicles { items, error in
    if let aItems = items {
      if let aItem = aItems.first {
        let props = aItem.getAllPropertyValues()
        debugPrint("props: \(props)")
      }
    }
    if let aError = error {
      debugPrint("error: \(aError)")
    }
  }
}

func testAPI() {
  StargazerCategory.fetchFilm(id: 1) { film, error in
    if let aFlm = film {
      let props = aFlm.getAllPropertyValues()
      debugPrint("props: \(props)")
    }
    if let aError = error {
      debugPrint("error: \(aError)")
    }
  }
}

func testAPIStarship() {
  StargazerCategory.fetchStarship(id: 9) { starship, error in
    if let aStarship = starship {
      let props = aStarship.getAllPropertyValues()
      debugPrint("props: \(props)")
    }
    if let aError = error {
      debugPrint("error: \(aError)")
    }
  }
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


