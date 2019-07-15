//
//  StargazerModels.swift
//  Stargazer
//
//  Created by Mihaela MJ on 14/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

// MARK: -
// MARK: Main Model -

class StargazerObjectModel {
}

class StargazerModel: StargazerObjectModel, Codable {
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

  var myId: Int? {
    return urlString?.id
  }

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

  init(name: String, category: StargazerCategory, created: Date, urlString: String) {
    self.name = name
    self.category = category
    self.created = created
    self.urlString = UrlStringItem(string: urlString)
  }
}

class StargazerBaseModel: StargazerModel, StargazerCategoryItemListAdapterProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    preconditionFailure("`genericTableView` needs to be overriden by concrete subscasses")
  }
}


// MARK: -
// MARK: Person -

class StargazerPerson: StargazerBaseModel {
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

    if let heightString = try values.decodeIfPresent(String.self, forKey: .height) {
      height = Int(heightString)
    }

    if let massString = try values.decodeIfPresent(String.self, forKey: .mass) {
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

  override func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let title = name ?? "n/a"
    let subtitle = birthYear ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: title, subtitle: subtitle, dateCreated: date, category: .people, id: myId)
  }
}

// MARK: -
// MARK: Specie -

class StargazerSpecie: StargazerBaseModel {
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

    if let heightString = try values.decodeIfPresent(String.self, forKey: .averageHeight) {
      averageHeight = Int(heightString)
    }

    if let lifeString = try values.decodeIfPresent(String.self, forKey: .averageLifespan) {
      averageLifespan = Int(lifeString)
    }

    if let eyeColorItems = try values.decodeIfPresent(CSVStringItems.self, forKey: .eyeColors) {
      eyeColors = eyeColorItems.toColorItems()
    }

    if let hairColorsItems = try values.decodeIfPresent(CSVStringItems.self, forKey: .hairColors) {
      hairColors = hairColorsItems.toColorItems()
    }

    if let skinColorItems = try values.decodeIfPresent(CSVStringItems.self, forKey: .skinColors) {
      skinColors = skinColorItems.toColorItems()
    }

    language = try values.decodeIfPresent(String.self, forKey: .language)
    homeworld = try values.decodeIfPresent(UrlStringItem.self, forKey: .homeworld)

    films = try values.decodeIfPresent(UrlStringItems.self, forKey: .films)
    if let aFilms = films { aFilms.category = .films }

    people = try values.decodeIfPresent(UrlStringItems.self, forKey: .people)
    if let aPeople = people { aPeople.category = .people }
  }

  // MARK: -
  // MARK: Adapter -

  override func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let title = name ?? "n/a"
    let subtitle = classification ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: title, subtitle: subtitle, dateCreated: date, category: .species, id: myId)
  }
}

// MARK: -
// MARK: Film -

class StargazerFilm: StargazerBaseModel {
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

    episodeId = try values.decodeIfPresent(Int.self, forKey: .episodeId)

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

  // MARK: -
  // MARK: Adapter -

  override func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = title?.initials(2) ?? ""
    let aTitle = title ?? "n/a"
    let subtitle = openingCrawl ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: aTitle, subtitle: subtitle, dateCreated: date, category: .films, id: myId)
  }
}

// MARK: -
// MARK: Starship -

class StargazerStarship: StargazerBaseModel {
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

    if let dblRating = try values.decodeIfPresent(String.self, forKey: .hyperdriveRating) {
      hyperdriveRating = Double(dblRating)
    }

    starshipClass = try values.decodeIfPresent(String.self, forKey: .starshipClass)
    mglt = try values.decodeIfPresent(String.self, forKey: .mglt)
  }

  // MARK: -
  // MARK: Adapter -

  override func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let aTitle = name ?? "n/a"
    let subtitle = vessel?.model ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: aTitle, subtitle: subtitle, dateCreated: date, category: .films, id: myId)
  }
}

// MARK: -
// MARK: Vehicle -

class StargazerVehicle: StargazerBaseModel {
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

  // MARK: -
  // MARK: Adapter -

  override func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let aTitle = name ?? "n/a"
    let subtitle = vessel?.model ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: aTitle, subtitle: subtitle, dateCreated: date, category: .films, id: myId)
  }
}

// MARK: -
// MARK: Planet -

class StargazerPlanet: StargazerBaseModel {
  var diameter: UInt? // string -- The diameter of this planet in kilometers.
  var rotationPeriod: Int? // string -- The number of standard hours it takes for this planet to complete a single rotation on its axis.
  var orbitalPeriod: Int? // string -- The number of standard days it takes for this planet to complete a single orbit of its local star.
  var gravity: Int? // string -- A number denoting the gravity of this planet, where "1" is normal or 1 standard G. "2" is twice or 2 standard Gs. "0.5" is half or 0.5 standard Gs.
  var population: UInt? // string -- The average population of sentient beings inhabiting this planet.

  var climate: CSVStringItems? // string -- The climate of this planet. Comma separated if diverse.
  var terrain: CSVStringItems? // string -- The terrain of this planet. Comma separated if diverse.

  var surfaceWater: Int? // string -- The percentage of the planet surface that is naturally occurring water or bodies of water.
  var residents: UrlStringItems? // array -- An array of People URL Resources that live on this planet.
  var films: UrlStringItems? // array -- An array of Film URL Resources that this species has appeared in.

  private enum CodingKeys: String, CodingKey {
    case diameter
    case rotationPeriod = "rotation_period"
    case orbitalPeriod = "orbital_period"
    case gravity
    case population

    case climate
    case terrain

    case surfaceWater = "surface_water"
    case residents
    case films
  }

  required init(from decoder: Decoder) throws {
    try super.init(from: decoder)
    category = .planets
    let values = try decoder.container(keyedBy: CodingKeys.self)

    if let uintDiameter = try values.decodeIfPresent(String.self, forKey: .diameter) {
      diameter = UInt(uintDiameter)
    }

    if let intRot = try values.decodeIfPresent(String.self, forKey: .rotationPeriod) {
      rotationPeriod = Int(intRot)
    }

    if let intOrb = try values.decodeIfPresent(String.self, forKey: .orbitalPeriod) {
      orbitalPeriod = Int(intOrb)
    }

    if let intGravity = try values.decodeIfPresent(String.self, forKey: .gravity) {
      gravity = Int(intGravity)
    }

    if let uintPop = try values.decodeIfPresent(String.self, forKey: .population) {
      population = UInt(uintPop)
    }

    climate = try values.decodeIfPresent(CSVStringItems.self, forKey: .climate)
    terrain = try values.decodeIfPresent(CSVStringItems.self, forKey: .terrain)

    residents = try values.decodeIfPresent(UrlStringItems.self, forKey: .residents)
    if let aResidents = residents { aResidents.category = .people }

    films = try values.decodeIfPresent(UrlStringItems.self, forKey: .films)
    if let aFilms = films { aFilms.category = .films }
  }

  // MARK: -
  // MARK: Adapter -

  override func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let aTitle = name ?? "n/a"
    var subtitle = "n/a"; if let aDieametar = diameter { subtitle = String(aDieametar) }
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: aTitle, subtitle: subtitle, dateCreated: date, category: .films, id: myId)
  }
}

