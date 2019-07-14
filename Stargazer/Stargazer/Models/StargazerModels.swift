//
//  StargazerModels.swift
//  Stargazer
//
//  Created by Mihaela MJ on 14/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

// MARK: -
// MARK: Helper Models -

class UrlStringItem {
  var urlString: String?
  var category: StargazerCategory?
  var id: Int?
}

class UrlStringItems {
  var items: [UrlStringItem]?
}


class CSVStringItems {
  var csvString: [String]?
  var items: [String]?
}

enum StargazerPersonColor: String, CaseIterable {
  case unknown
  case notAvailable
}

enum StargazerGender: String, CaseIterable {
  case unknown
  case notAvailable
  case male
  case female
}

// MARK: -
// MARK: Main Model -

class StargazerModel: Codable {
  var category: StargazerCategory?
  var name: String?
  var url: String? // string -- the hypermedia URL of this resource.
  var created: String? // string -- the ISO 8601 date format of the time that this resource was created.
  var edited: String? // string -- the ISO 8601 date format of the time that this resource was edited.

  private enum CodingKeys: String, CodingKey {
    case name
    case url
    case created
    case edited
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(url, forKey: .url)
    try container.encode(created, forKey: .created)
    try container.encode(edited, forKey: .edited)
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
  }
}

// MARK: -
// MARK: Person -

class StargazerPerson: StargazerModel {
  var birthYear: String? // string -- The birth year of the person, using the in-universe standard of BBY or ABY - Before the Battle of Yavin or After the Battle of Yavin. The Battle of Yavin is a battle that occurs at the end of Star Wars episode IV: A New Hope.

  var eyeColor: StargazerPersonColor? // string -- The eye color of this person. Will be "unknown" if not known or "n/a" if the person does not have an eye.
  var hairColor: StargazerPersonColor? // string -- The hair color of this person. Will be "unknown" if not known or "n/a" if the person does not have hair.
  var skinColor: StargazerPersonColor? // string -- The skin color of this person

  var gender: StargazerGender? //string -- The gender of this person. Either "Male", "Female" or "unknown", "n/a" if the person does not have a gender.

  var height: String? // string -- The height of the person in centimeters.
  var mass: String? // string -- The mass of the person in kilograms..
  var homeworld: String? // string -- The URL of a planet resource, a planet that this person was born on or inhabits.
  var films: UrlStringItems? // array -- An array of film resource URLs that this person has been in.
  var species: UrlStringItems? // array -- An array of species resource URLs that this person belongs to.
  var starships: UrlStringItems? // array -- An array of starship resource URLs that this person has piloted.
  var vehicles: UrlStringItems? // array -- An array of vehicle resource URLs that this person has piloted.

  private enum CodingKeys: String, CodingKey {
    case birthYear = "birth_year"
    case eyeColor = "eye_color"
    case hairColor = "hair_color"
    case skinColor = "skin_color"
    case gender
    case height
    case mass
    case homeworld
    case films
    case species
    case starships
    case vehicles
  }

  required init(from decoder: Decoder) throws {
    try super.init(from: decoder)
    let values = try decoder.container(keyedBy: CodingKeys.self)
  }
}


// MARK: -
// MARK: Film -

class StargazerFilm: StargazerModel {
  var title: String? // string -- The title of this film
  var episodeId: Int? // integer -- The episode number of this film.
  var openingCrawl: String? // string -- The opening paragraphs at the beginning of this film.
  var director: String? // string -- The name of the director of this film.
  var producer: CSVStringItems? // string -- The name(s) of the producer(s) of this film. Comma separated. "Gary Kurtz, Rick McCallum"
  var releaseDate: String? // date -- The ISO 8601 date format of film release at original creator country.
  var species: UrlStringItems? // array -- An array of species resource URLs that are in this film.
  var starships: UrlStringItems? // array -- An array of starship resource URLs that are in this film.
  var vehicles: UrlStringItems? // array -- An array of vehicle resource URLs that are in this film.
  var characters: UrlStringItems? // array -- An array of people resource URLs that are in this film.
  var planets: UrlStringItems? // array -- An array of planet resource URLs that are in this film.

  private enum CodingKeys: String, CodingKey {
    case episodeId = "episode_id"
    case openingCrawl = "opening_crawl"
    case releaseDate = "release_date"
    case title
    case director
    case producer
    case species
    case starships
    case vehicles
    case characters
    case planets
  }

  required init(from decoder: Decoder) throws {
    try super.init(from: decoder)
    let values = try decoder.container(keyedBy: CodingKeys.self)
  }
}

// MARK: -
// MARK: Vessel -

class StargazerVessel: StargazerModel {
  var model: String? // string -- The model or official name of this starship. Such as "T-65 X-wing" or "DS-1 Orbital Battle Station".
  var manufacturer: CSVStringItems? // string -- The manufacturer of this starship. Comma separated if more than one. "Imperial Department of Military Research, Sienar Fleet Systems"
  var length: String? // string -- The length of this starship in meters.
  var costInCredits: String? // string -- The cost of this starship new, in galactic credits.
  var crew: String? // string -- The number of personnel needed to run or pilot this starship.
  var passengers: String? // string -- The number of non-essential people this starship can transport.
  var consumables: String? // *string //The maximum length of time that this starship can provide consumables for its entire crew without having to resupply.
  var maxAtmospheringSpeed: String? // string -- The maximum speed of this starship in the atmosphere. "N/A" if this starship is incapable of atmospheric flight.
  var cargoCapacity: String? // string -- The maximum number of kilograms that this starship can transport.
  var pilots: UrlStringItems? // array -- An array of People URL Resources that this starship has been piloted by.

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
  }
}

// MARK: -
// MARK: Starship -

class StargazerStarship: StargazerModel {
//  var name: String? // string -- The name of this starship. The common name, such as "Death Star".
//  var model: String? // string -- The model or official name of this starship. Such as "T-65 X-wing" or "DS-1 Orbital Battle Station".
//  var manufacturer: CSVStringItems? // string -- The manufacturer of this starship. Comma separated if more than one. "Imperial Department of Military Research, Sienar Fleet Systems"
//  var length: String? // string -- The length of this starship in meters.
//  var costInCredits: String? // string -- The cost of this starship new, in galactic credits.
//  var crew: String? // string -- The number of personnel needed to run or pilot this starship.
//  var passengers: String? // string -- The number of non-essential people this starship can transport.
//  var consumables: String? // *string //The maximum length of time that this starship can provide consumables for its entire crew without having to resupply.
//  var maxAtmospheringSpeed: String? // string -- The maximum speed of this starship in the atmosphere. "N/A" if this starship is incapable of atmospheric flight.
//  var cargoCapacity: String? // string -- The maximum number of kilograms that this starship can transport.
//  var pilots: UrlStringItems? // array -- An array of People URL Resources that this starship has been piloted by.


  var vessel: StargazerVessel?
  var starshipClass: String? // string -- The class of this starship, such as "Starfighter" or "Deep Space Mobile Battlestation"
  var hyperdriveRating: String? // string -- The class of this starships hyperdrive.
  var mglt: String? // string -- The Maximum number of Megalights this starship can travel in a standard hour. A "Megalight" is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth.
  var films: UrlStringItems? // array -- An array of Film URL Resources that this starship has appeared in.

  private enum CodingKeys: String, CodingKey {
//    case model
//    case manufacturer
//    case length
//    case costInCredits = "cost_in_credits"
//    case crew
//    case passengers
//    case consumables
//    case maxAtmospheringSpeed = "max_atmosphering_speed"
//    case cargoCapacity = "cargo_capacity"
//    case pilots

    case starshipClass
    case hyperdriveRating
    case mglt = "MGLT"
    case films
  }

  required init(from decoder: Decoder) throws {
    try super.init(from: decoder)
    let values = try decoder.container(keyedBy: CodingKeys.self)
  }
}

// MARK: -
// MARK: Vehicle -

class StargazerVehicle: StargazerModel {
//  var name: String? // string -- The name of this vehicle. The common name, such as "Sand Crawler" or "Speeder bike".

  var model: String? // string -- The model or official name of this vehicle. Such as "All-Terrain Attack Transport".
  var manufacturer: CSVStringItems? // string -- The manufacturer of this vehicle. Comma separated if more than one.
  var length: String? // string -- The length of this vehicle in meters.
  var costInCredits: String? // string -- The cost of this vehicle new, in Galactic Credits.
  var crew: String? // string -- The number of personnel needed to run or pilot this vehicle.
  var passengers: String? // string -- The number of non-essential people this vehicle can transport.
  var consumables: String? // *string //The maximum length of time that this vehicle can provide consumables for its entire crew without having to resupply.
  var maxAtmospheringSpeed: String? // string -- The maximum speed of this vehicle in the atmosphere.
  var cargoCapacity: String? // string -- The maximum number of kilograms that this vehicle can transport.
  var pilots: UrlStringItems? // array -- An array of People URL Resources that this vehicle has been piloted by.


  var vehicle_class: String? // string -- The class of this vehicle, such as "Wheeled" or "Repulsorcraft".
  var films: UrlStringItems? // array -- An array of Film URL Resources that this vehicle has appeared in.


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

    case vehicle_class = "vehicle_class"
    case films
  }
}

// MARK: -
// MARK: Specie -

class StargazerSpecie: StargazerModel {
  var classification: String? // string -- The classification of this species, such as "mammal" or "reptile".
  var designation: String? // string -- The designation of this species, such as "sentient".
  var average_height: String? // string -- The average height of this species in centimeters.
  var average_lifespan: String? // string -- The average lifespan of this species in years.

  var eye_colors: [StargazerPersonColor]? // string -- A comma-separated string of common eye colors for this species, "none" if this species does not typically have eyes.
  var hair_colors: [StargazerPersonColor]? // string -- A comma-separated string of common hair colors for this species, "none" if this species does not typically have hair.
  var skin_colors: [StargazerPersonColor]? // string -- A comma-separated string of common skin colors for this species, "none" if this species does not typically have skin.

  var language: String? // string -- The language commonly spoken by this species.
  var homeworld: String? // string -- The URL of a planet resource, a planet that this species originates from.

  var people: UrlStringItems? // array -- An array of People URL Resources that are a part of this species.
  var films: UrlStringItems? // array -- An array of Film URL Resources that this species has appeared in.
}

// MARK: -
// MARK: Planet -

class StargazerPlanet: StargazerModel {
  var diameter: String? // string -- The diameter of this planet in kilometers.
  var rotation_period: String? // string -- The number of standard hours it takes for this planet to complete a single rotation on its axis.
  var orbital_period: String? // string -- The number of standard days it takes for this planet to complete a single orbit of its local star.
  var gravity: String? // string -- A number denoting the gravity of this planet, where "1" is normal or 1 standard G. "2" is twice or 2 standard Gs. "0.5" is half or 0.5 standard Gs.
  var population: String? // string -- The average population of sentient beings inhabiting this planet.

  var climate: CSVStringItems? // string -- The climate of this planet. Comma separated if diverse.
  var terrain: CSVStringItems? // string -- The terrain of this planet. Comma separated if diverse.

  var surface_water: String? // string -- The percentage of the planet surface that is naturally occurring water or bodies of water.
  var residents: UrlStringItems? // array -- An array of People URL Resources that live on this planet.
  var films: UrlStringItems? // array -- An array of Film URL Resources that this species has appeared in.
}

