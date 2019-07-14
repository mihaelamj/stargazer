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
      if let aUrlString = urlString {
        url = URL(string: aUrlString)
        if let baseUrl = URL(string: StargazerConstants.baseURL) {
          if let components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) {
            //path : "/api/v1.0"
            if let lastPart = components.path.components(separatedBy: "/").last {
              id = Int(lastPart)
            }
          }
        }
      }

    } catch {}
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
}

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

// MARK: -
// MARK: Vessel -

class StargazerVessel: Codable {
  var model: String? // string -- The model or official name of this starship. Such as "T-65 X-wing" or "DS-1 Orbital Battle Station".
  var manufacturer: CSVStringItems? // string -- The manufacturer of this starship. Comma separated if more than one. "Imperial Department of Military Research, Sienar Fleet Systems"
  var length: Int? // string -- The length of this starship in meters.
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

    if let intLength = try values.decodeIfPresent(Int.self, forKey: .length) {
      length = Int(intLength)
    }

    if let uintCost = try values.decodeIfPresent(Int.self, forKey: .costInCredits) {
      costInCredits = UInt(uintCost)
    }

    if let uintCargo = try values.decodeIfPresent(Int.self, forKey: .cargoCapacity) {
      cargoCapacity = UInt(uintCargo)
    }

    if let intCrew = try values.decodeIfPresent(Int.self, forKey: .crew) {
      crew = Int(intCrew)
    }

    if let intPass = try values.decodeIfPresent(Int.self, forKey: .passengers) {
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
