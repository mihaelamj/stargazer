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

//  init(from decoder: Decoder) throws {
//    let container = try decoder.singleValueContainer()
//    do {
//      let item = try container.decode(String.self)
//      let type = StargazerGender(with: item)
//      self = type
//    } catch {}
//  }
}

// MARK: -
// MARK: Main Model -

class StargazerModel: Codable {
  var category: StargazerCategory? {
    didSet {
      if let aUrlsString = urlString {
        aUrlsString.category = category
      }
    }
  }
  var name: String?
  var urlString: UrlStringItem? // string -- the hypermedia URL of this resource.
  var created: Date? // string -- the ISO 8601 date format of the time that this resource was created.
  var edited: Date? // string -- the ISO 8601 date format of the time that this resource was edited.

  private enum CodingKeys: String, CodingKey {
    case name
    case urlString = "url"
    case created
    case edited
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)


    try container.encode(name, forKey: .name)
//    try container.encode(urlString, forKey: .urlString)
    try container.encode(created, forKey: .created)
    try container.encode(edited, forKey: .edited)
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    urlString = try values.decodeIfPresent(UrlStringItem.self, forKey: .urlString)

    if let createdString = try values.decodeIfPresent(String.self, forKey: .created) {
      created = createdString.iso8601
    }

    if let modifiedString = try values.decodeIfPresent(String.self, forKey: .edited) {
      edited = modifiedString.iso8601
    }

    name = try values.decodeIfPresent(String.self, forKey: .name)
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

  var height: Int? // string -- The height of the person in centimeters.
  var mass: Int? // string -- The mass of the person in kilograms..
  var homeworld: UrlStringItem? // string -- The URL of a planet resource, a planet that this person was born on or inhabits.

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
    category = .people
    let values = try decoder.container(keyedBy: CodingKeys.self)

    birthYear = try values.decodeIfPresent(String.self, forKey: .birthYear)

    eyeColor = try values.decodeIfPresent(StargazerPersonColor.self, forKey: .eyeColor)
    hairColor = try values.decodeIfPresent(StargazerPersonColor.self, forKey: .hairColor)
    skinColor = try values.decodeIfPresent(StargazerPersonColor.self, forKey: .skinColor)

    if let genderString = try values.decodeIfPresent(String.self, forKey: .gender) {
      gender = StargazerGender(with: genderString)
    }

    if let heightString = try values.decodeIfPresent(Int.self, forKey: .height) {
      height = Int(heightString)
    }

    if let massString = try values.decodeIfPresent(Int.self, forKey: .mass) {
      mass = Int(massString)
    }

    homeworld = try values.decodeIfPresent(UrlStringItem.self, forKey: .homeworld)

    films = try values.decodeIfPresent(UrlStringItems.self, forKey: .films)
    if let aFilms = films { aFilms.category = .films }

    species = try values.decodeIfPresent(UrlStringItems.self, forKey: .species)
    if let aSpecies = species { aSpecies.category = .species }

    starships = try values.decodeIfPresent(UrlStringItems.self, forKey: .starships)
    if let aStarships = starships { aStarships.category = .starships }

    vehicles = try values.decodeIfPresent(UrlStringItems.self, forKey: .vehicles)
    if let aVehicles = vehicles { aVehicles.category = .vehicles }

  }
}

// MARK: -
// MARK: Specie -

class StargazerSpecie: StargazerModel {
  var classification: String? // string -- The classification of this species, such as "mammal" or "reptile".
  var designation: String? // string -- The designation of this species, such as "sentient".
  var averageHeight: Int? // string -- The average height of this species in centimeters.
  var averageLifespan: Int? // string -- The average lifespan of this species in years.

  var eyeColors: [StargazerPersonColor]? // string -- A comma-separated string of common eye colors for this species, "none" if this species does not typically have eyes.
  var hairColors: [StargazerPersonColor]? // string -- A comma-separated string of common hair colors for this species, "none" if this species does not typically have hair.
  var skinColors: [StargazerPersonColor]? // string -- A comma-separated string of common skin colors for this species, "none" if this species does not typically have skin.

  var language: String? // string -- The language commonly spoken by this species.
  var homeworld: UrlStringItem? // string -- The URL of a planet resource, a planet that this species originates from.

  var people: UrlStringItems? // array -- An array of People URL Resources that are a part of this species.
  var films: UrlStringItems? // array -- An array of Film URL Resources that this species has appeared in.

  private enum CodingKeys: String, CodingKey {
    case classification
    case designation
    case averageHeight = "average_height"
    case averageLifespan = "average_lifespan"
    case eyeColors = "eye_colors"
    case hairColors = "hair_colors"
    case skinColors = "skin_colors"

    case language
    case homeworld

    case people
    case films
  }

  required init(from decoder: Decoder) throws {
    try super.init(from: decoder)
    category = .species
    let values = try decoder.container(keyedBy: CodingKeys.self)

    classification = try values.decodeIfPresent(String.self, forKey: .classification)
    designation = try values.decodeIfPresent(String.self, forKey: .designation)

    if let heightString = try values.decodeIfPresent(Int.self, forKey: .averageHeight) {
      averageHeight = Int(heightString)
    }

    if let lifeString = try values.decodeIfPresent(Int.self, forKey: .averageLifespan) {
      averageLifespan = Int(lifeString)
    }

    eyeColors = try values.decodeIfPresent([StargazerPersonColor].self, forKey: .eyeColors)
    hairColors = try values.decodeIfPresent([StargazerPersonColor].self, forKey: .hairColors)
    skinColors = try values.decodeIfPresent([StargazerPersonColor].self, forKey: .skinColors)

    language = try values.decodeIfPresent(String.self, forKey: .language)
    homeworld = try values.decodeIfPresent(UrlStringItem.self, forKey: .homeworld)

    films = try values.decodeIfPresent(UrlStringItems.self, forKey: .films)
    if let aFilms = films { aFilms.category = .films }

    people = try values.decodeIfPresent(UrlStringItems.self, forKey: .people)
    if let aPeople = people { aPeople.category = .people }
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
  var releaseDate: Date? // date -- The ISO 8601 date format of film release at original creator country.

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
    category = .films
    let values = try decoder.container(keyedBy: CodingKeys.self)

    title = try values.decodeIfPresent(String.self, forKey: .title)
    openingCrawl = try values.decodeIfPresent(String.self, forKey: .openingCrawl)
    director = try values.decodeIfPresent(String.self, forKey: .director)

    if let idString = try values.decodeIfPresent(Int.self, forKey: .episodeId) {
      episodeId = Int(idString)
    }

    producer = try values.decodeIfPresent(CSVStringItems.self, forKey: .producer)

    if let releaseDateString = try values.decodeIfPresent(String.self, forKey: .releaseDate) {
      releaseDate = releaseDateString.iso8601
    }

    species = try values.decodeIfPresent(UrlStringItems.self, forKey: .species)
    if let aSpecies = species { aSpecies.category = .species }

    starships = try values.decodeIfPresent(UrlStringItems.self, forKey: .starships)
    if let aStarships = starships { aStarships.category = .starships }

    vehicles = try values.decodeIfPresent(UrlStringItems.self, forKey: .vehicles)
    if let aVehicles = vehicles { aVehicles.category = .vehicles }

    characters = try values.decodeIfPresent(UrlStringItems.self, forKey: .characters)
    if let aCharacters = characters { aCharacters.category = .people }

    planets = try values.decodeIfPresent(UrlStringItems.self, forKey: .planets)
    if let aPlanets = planets { aPlanets.category = .planets }
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

// MARK: -
// MARK: Starship -

class StargazerStarship: StargazerModel {
  var vessel: StargazerVessel?

  var starshipClass: String? // string -- The class of this starship, such as "Starfighter" or "Deep Space Mobile Battlestation"
  var hyperdriveRating: Double? // string -- The class of this starships hyperdrive.
  var mglt: String? // string -- The Maximum number of Megalights this starship can travel in a standard hour. A "Megalight" is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth.

  private enum CodingKeys: String, CodingKey {
    case starshipClass
    case hyperdriveRating
    case mglt = "MGLT"
  }

  required init(from decoder: Decoder) throws {
    try super.init(from: decoder)
    category = .starships
    let values = try decoder.container(keyedBy: CodingKeys.self)

    do {
      vessel = try StargazerVessel(from: decoder)
    } catch {
      print(error)
    }

    if let dblRating = try values.decodeIfPresent(Double.self, forKey: .hyperdriveRating) {
      hyperdriveRating = Double(dblRating)
    }

    starshipClass = try values.decodeIfPresent(String.self, forKey: .starshipClass)
    mglt = try values.decodeIfPresent(String.self, forKey: .mglt)
  }
}

// MARK: -
// MARK: Vehicle -

class StargazerVehicle: StargazerModel {
  var vessel: StargazerVessel?

  var vehicleClass: String? // string -- The class of this vehicle, such as "Wheeled" or "Repulsorcraft".

  private enum CodingKeys: String, CodingKey {
    case vehicleClass = "vehicle_class"
  }

  required init(from decoder: Decoder) throws {
    try super.init(from: decoder)
    category = .vehicles
    let values = try decoder.container(keyedBy: CodingKeys.self)

    do {
      vessel = try StargazerVessel(from: decoder)
    } catch {
      print(error)
    }

    vehicleClass = try values.decodeIfPresent(String.self, forKey: .vehicleClass)
  }
}

// MARK: -
// MARK: Planet -

class StargazerPlanet: StargazerModel {
  var diameter: String? // string -- The diameter of this planet in kilometers.
  var rotationPeriod: String? // string -- The number of standard hours it takes for this planet to complete a single rotation on its axis.
  var orbitalPeriod: String? // string -- The number of standard days it takes for this planet to complete a single orbit of its local star.
  var gravity: String? // string -- A number denoting the gravity of this planet, where "1" is normal or 1 standard G. "2" is twice or 2 standard Gs. "0.5" is half or 0.5 standard Gs.
  var population: String? // string -- The average population of sentient beings inhabiting this planet.

  var climate: CSVStringItems? // string -- The climate of this planet. Comma separated if diverse.
  var terrain: CSVStringItems? // string -- The terrain of this planet. Comma separated if diverse.

  var surfaceWater: String? // string -- The percentage of the planet surface that is naturally occurring water or bodies of water.
  var residents: UrlStringItems? // array -- An array of People URL Resources that live on this planet.
  var films: UrlStringItems? // array -- An array of Film URL Resources that this species has appeared in.

  private enum CodingKeys: String, CodingKey {
    case diameter
    case rotationPeriod = "rotation_period"
    case orbitalPeriod = "orbital_period"
    case gravity
    case population

    case climate
    case terrai

    case surfaceWater = "surface_water"
    case residents
    case films
  }

  required init(from decoder: Decoder) throws {
    try super.init(from: decoder)
    category = .planets
    let values = try decoder.container(keyedBy: CodingKeys.self)
  }
}

