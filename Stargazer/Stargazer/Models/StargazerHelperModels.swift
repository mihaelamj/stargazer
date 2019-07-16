//
//  StargazerHelperModels.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

// MARK: -
// MARK: Helper Models -

class UrlStringItem: Decodable {
  var urlString: String?
  var url: URL?
  var id: Int?
  var category: StargazerCategory?

  required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      urlString = try container.decode(String.self)
      if let aUrlStr = urlString {
        let props = UrlStringItem.getUrlProperties(string: aUrlStr)
        url = props.url
        id = props.id
      }

    } catch {}
  }

  init(string: String) {
    urlString = string
    let props = UrlStringItem.getUrlProperties(string: string)
    url = props.url
    id = props.id
  }

  private static func getUrlProperties(string: String) -> (url: URL?, id: Int?) {
    var resultUrl: URL?; var resultId: Int?
    guard let aUrl = URL(string: string) else { return (url: resultUrl, id: resultId) }
    resultUrl = aUrl
    guard let components = URLComponents(url: aUrl, resolvingAgainstBaseURL: true) else {
      return (url: resultUrl, id: resultId)
    }
    let parts = components.path.components(separatedBy: "/")
    for part in parts {
      if let aInt = Int(part) {
        resultId = aInt
        break
      }
    }
//    if let lastPart = parts.last { resultId = Int(lastPart) }
    return (url: resultUrl, id: resultId)
  }
}

extension UrlStringItem: CustomStringConvertible {
  public var description: String {
    var result = ""
    if let aUrl = url {
      result = "\(aUrl)"
    } else if let aUrlString = urlString {
      result = "-" + aUrlString
    }
    if let aCat = category {
      result = result + ", c= \(aCat)"
    }
    if let aId = id {
      result = result + ", id= \(aId)"
    }
    return result
  }
}

class UrlStringItems: Decodable {
  var items: [UrlStringItem]?
  var category: StargazerCategory? {
    didSet {
      if let aItems = items {
        aItems.forEach { $0.category = category }
      }
    }
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      //      let urlItems = try container.decode([String].self)
      items = try container.decode([UrlStringItem].self)
    } catch {}
  }
}

extension UrlStringItems: CustomStringConvertible {
  var description: String {
    if let aItems = items {
      let aStrs = aItems.map { return $0.description}
      return aStrs.joined(separator: ",")
    }
    return "N/A"
  }
}

class CSVStringItems: Decodable {
  var items: [String]?

  required init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      let csvItems = try container.decode(String.self)
      items = csvItems.components(separatedBy: ",")
    } catch {}
  }
}

extension CSVStringItems: CustomStringConvertible {
  public var description: String {
    if let aItems = items {
      return aItems.joined(separator: ",")
    }
    return "N/A"
  }
}

extension CSVStringItems {
  func toColorItems() -> [StargazerPersonColor]? {
    guard let aItems = items else { return nil }
    let res = aItems.map { return StargazerPersonColor(from: $0) }
    return res
  }
}

// Will be "unknown" if not known or "n/a" if the person does not have an eye.

enum StargazerPersonColorType: String, CaseIterable {
  case unknown = "unknown"
  case notAvailable = "n/a"
  case color

  init(with title: String) {
    let fixedTitle = title.caseless
    switch fixedTitle {
    case StargazerPersonColorType.unknown.rawValue.caseless:
      self = .unknown
    case StargazerPersonColorType.notAvailable.rawValue.caseless:
      self = .notAvailable
    default:
      self = .color
    }
  }
}

extension StargazerPersonColorType: CustomStringConvertible {
  public var description: String {
    return "\(rawValue)"
  }
}

struct StargazerPersonColor: Decodable {
  var type: StargazerPersonColorType = .unknown
  var value: String?

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      let item = try container.decode(String.self)
      type = StargazerPersonColorType(with: item)
      if type == .color { value = item }
    } catch {}
  }

  init(from string: String) {
    type = StargazerPersonColorType(with: string)
    if type == .color { value = string }
  }
}

extension StargazerPersonColor: CustomStringConvertible {
  public var description: String {
    var result = type.rawValue
    if let aValue = value {
      result = result + ": \(aValue)"
    }
    return result
  }
}

//"eye_colors": "blue, green, yellow, brown, golden, red"


// "Male", "Female" or "unknown", "n/a"
enum StargazerGender: String, CaseIterable {
  case unknown = "unknown"
  case notAvailable = "n/a"
  case male = "Male"
  case female = "Female"

  init(with title: String) {
    let fixedTitle = title.caseless
    switch fixedTitle {
    case StargazerGender.unknown.rawValue.caseless:
      self = .unknown
    case StargazerGender.notAvailable.rawValue.caseless:
      self = .notAvailable
    case StargazerGender.male.rawValue.caseless:
      self = .male
    case StargazerGender.female.rawValue.caseless:
      self = .female
    default:
      self = .unknown
    }
  }
}

extension StargazerGender: CustomStringConvertible {
  public var description: String {
    return "\(rawValue)"
  }
}

// MARK: -
// MARK: Vessel -

class StargazerVessel: StargazerObjectModel {
  var model: String? // string -- The model or official name of this starship. Such as "T-65 X-wing" or "DS-1 Orbital Battle Station".
  var manufacturer: CSVStringItems? // string -- The manufacturer of this starship. Comma separated if more than one. "Imperial Department of Military Research, Sienar Fleet Systems"
  var length: Double? // string -- The length of this starship in meters.
  var costInCredits: UInt? // string -- The cost of this starship new, in galactic credits.
  var crew: Int? // string -- The number of personnel needed to run or pilot this starship.
  var passengers: Int? // string -- The number of non-essential people this starship can transport.
  var consumables: String? // *string //The maximum length of time that this starship can provide consumables for its entire crew without having to resupply.
  var maxAtmospheringSpeed: String? // string -- The maximum speed of this starship in the atmosphere. "N/A" if this starship is incapable of atmospheric flight.
  var cargoCapacity: UInt? // string -- The maximum number of kilograms that this starship can transport.
  var pilots: UrlStringItems? // array -- An array of People URL Resources that this starship has been piloted by.
  var films: UrlStringItems? // array -- An array of Film URL Resources that this starship has appeared in.

  private enum CodingKeys: String, CodingKey {
    case model
    case manufacturer
    case length
    case costInCredits = "cost_in_credits"
    case crew
    case passengers
    case consumables
    case maxAtmospheringSpeed = "max_atmosphering_speed"
    case cargoCapacity = "cargo_capacity"
    case pilots
    case films
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(model, forKey: .model)
    //    try container.encode(manufacturer, forKey: .manufacturer)
    try container.encode(length, forKey: .length)
    try container.encode(costInCredits, forKey: .costInCredits)
    try container.encode(crew, forKey: .crew)
    try container.encode(passengers, forKey: .passengers)
    try container.encode(consumables, forKey: .consumables)
    try container.encode(maxAtmospheringSpeed, forKey: .maxAtmospheringSpeed)
    try container.encode(cargoCapacity, forKey: .cargoCapacity)
    //    try container.encode(pilots, forKey: .pilots)
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    model = try values.decodeIfPresent(String.self, forKey: .model)

    manufacturer = try values.decodeIfPresent(CSVStringItems.self, forKey: .manufacturer)

    if let dblLength = try values.decodeIfPresent(String.self, forKey: .length) {
      length = Double(dblLength)
    }

    if let uintCost = try values.decodeIfPresent(String.self, forKey: .costInCredits) {
      costInCredits = UInt(uintCost)
    }

    if let uintCargo = try values.decodeIfPresent(String.self, forKey: .cargoCapacity) {
      cargoCapacity = UInt(uintCargo)
    }

    if let intCrew = try values.decodeIfPresent(String.self, forKey: .crew) {
      crew = Int(intCrew)
    }

    if let intPass = try values.decodeIfPresent(String.self, forKey: .passengers) {
      passengers = Int(intPass)
    }

    consumables = try values.decodeIfPresent(String.self, forKey: .consumables)
    maxAtmospheringSpeed = try values.decodeIfPresent(String.self, forKey: .maxAtmospheringSpeed)

    pilots = try values.decodeIfPresent(UrlStringItems.self, forKey: .pilots)
    if let aPilots = pilots { aPilots.category = .people }

    films = try values.decodeIfPresent(UrlStringItems.self, forKey: .films)
    if let aFilms = films { aFilms.category = .films }

  }
}

