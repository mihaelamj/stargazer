//
//  StargazerAPI.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

// MARK: -
// MARK: Base -

extension StargazerCategory {
  var baseURLString: String {
    return StargazerConstants.baseURL
  }

  var path: String {
    return "\(baseURLString)\(rawValue)/"
//    return baseURLString + rawValue + "/"
  }

  func pathWithId(_ id: Int) -> String {
    return "\(path)\(id)"
  }
}

// MARK: -
// MARK: Request -

private extension StargazerCategory {

  func sendRequest(request: URLRequest, completion: @escaping(_ data: Data?, _ error: Error?) -> Void) {
    let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
      if let aError = err {
        debugPrint("Error: \(aError)")
        debugPrint("response: \(String(describing: response))")
        completion(nil, err)
      } else {
        if let aData = data {
          let str = String(data: aData, encoding: .utf8)
          debugPrint("\(String(describing: str))")
        }
        completion(data, nil)
      }
    }
    task.resume()
  }

  func execute(id: Int?, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
    //make URL
    var myPathString = path
    if let aId = id { myPathString = pathWithId(aId) }
    guard let url = URL(string: myPathString) else {
      completion(nil, nil)
      return
    }

    debugPrint("url: \(url)")

    // make request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.timeoutInterval = 55

    //execute request
    sendRequest(request: request) { data, error in
      completion(data, error)
    }
  }
}

// MARK: -
// MARK: Result -

class StargazerResultDictionary<T>: Decodable where T: Decodable {
  var count: Int?
  var previous: String?
  var next: String?
  var results: [T]?

  private enum CodingKeys: String, CodingKey {
    case count
    case previous
    case next
    case results
  }

  required init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    count = try values.decodeIfPresent(Int.self, forKey: .count)
    previous = try values.decodeIfPresent(String.self, forKey: .previous)
    next = try values.decodeIfPresent(String.self, forKey: .next)
    results = try values.decodeIfPresent([T].self, forKey: .results)
  }
}

// MARK: -
// MARK: Generic -

private extension StargazerCategory {

  func fetchCollection<T>(type: T.Type, completion: @escaping (_ resultDictionary: StargazerResultDictionary<T>?, _ error: Error?) -> Void) where T: Decodable {
    execute(id: nil) { data, error in
      if let aData = data {
        do {
          let result = try JSONDecoder().decode(StargazerResultDictionary<T>.self, from: aData)
          DispatchQueue.main.async { completion(result, nil) }
        } catch {
          DispatchQueue.main.async { completion(nil, error) }
        }
      } else {
        DispatchQueue.main.async { completion(nil, error) }
      }
    }
  }

  func fetchOne<T>(id: Int?, completion: @escaping (_ item: T?, _ error: Error?) -> Void) where T: Decodable {
    execute(id: id) { data, error in
      if let aData = data {
        do {
          let result = try JSONDecoder().decode(T.self, from: aData)
          DispatchQueue.main.async { completion(result, nil) }
        } catch {
          DispatchQueue.main.async { completion(nil, error) }
        }
      } else {
        DispatchQueue.main.async { completion(nil, error) }
      }
    }
  }
}

// MARK: -
// MARK: Collection -

extension StargazerCategory {

  static func fetchPeople(completion: @escaping (_ items: [StargazerPerson]?, _ error: Error?) -> Void) {
    StargazerCategory.people.fetchCollection(type: StargazerPerson.self) { resultDict, error in
      completion(resultDict?.results, error)
    }
  }

  static func fetchSpecies(completion: @escaping (_ items: [StargazerSpecie]?, _ error: Error?) -> Void) {
    StargazerCategory.species.fetchCollection(type: StargazerSpecie.self) { resultDict, error in
      completion(resultDict?.results, error)
    }
  }

  static func fetchFilms(completion: @escaping (_ items: [StargazerFilm]?, _ error: Error?) -> Void) {
    StargazerCategory.films.fetchCollection(type: StargazerFilm.self) { resultDict, error in
      completion(resultDict?.results, error)
    }
  }

  static func fetchStarships(completion: @escaping (_ items: [StargazerStarship]?, _ error: Error?) -> Void) {
    StargazerCategory.starships.fetchCollection(type: StargazerStarship.self) { resultDict, error in
      completion(resultDict?.results, error)
    }
  }

  static func fetchVehicles(completion: @escaping (_ items: [StargazerVehicle]?, _ error: Error?) -> Void) {
    StargazerCategory.vehicles.fetchCollection(type: StargazerVehicle.self) { resultDict, error in
      completion(resultDict?.results, error)
    }
  }

  static func fetchPlanets(completion: @escaping (_ items: [StargazerStarship]?, _ error: Error?) -> Void) {
    StargazerCategory.planets.fetchCollection(type: StargazerStarship.self) { resultDict, error in
      completion(resultDict?.results, error)
    }
  }
}

// MARK: -
// MARK: Object -

extension StargazerCategory {

  static func fetchPerson(id: Int, completion: @escaping (_ item: StargazerPerson?, _ error: Error?) -> Void) {
    StargazerCategory.people.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }


  static func fetchSpecie(id: Int, completion: @escaping (_ item: StargazerSpecie?, _ error: Error?) -> Void) {
    StargazerCategory.species.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

  static func fetchFilm(id: Int, completion: @escaping (_ item: StargazerFilm?, _ error: Error?) -> Void) {
    StargazerCategory.films.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

  static func fetchStarship(id: Int, completion: @escaping (_ item: StargazerStarship?, _ error: Error?) -> Void) {
    StargazerCategory.starships.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

  static func fetchVehicle(id: Int, completion: @escaping (_ item: StargazerVehicle?, _ error: Error?) -> Void) {
    StargazerCategory.vehicles.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

  static func fetchPlanet(id: Int, completion: @escaping (_ item: StargazerPlanet?, _ error: Error?) -> Void) {
    StargazerCategory.planets.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

}

// MARK: -
// MARK: Helper -

extension StargazerCategory {

  func fetchItems(completion: @escaping (_ items: [StargazerBaseModel]?, _ error: Error?) -> Void) {
    switch self {
    case .people:
      StargazerCategory.fetchPeople { peopleItems, theError in
        completion(peopleItems, theError)
      }
    case .films:
      StargazerCategory.fetchFilms { filmItems, theError in
        completion(filmItems, theError)
      }
    case .starships:
      StargazerCategory.fetchStarships { starshipItems, theError in
        completion(starshipItems, theError)
      }
    case .vehicles:
      StargazerCategory.fetchVehicles { vehicleItems, theError in
        completion(vehicleItems, theError)
      }
    case .species:
      StargazerCategory.fetchSpecies { specieItems, theError in
        completion(specieItems, theError)
      }
    case .planets:
      StargazerCategory.fetchPlanets { planetItems, theError in
        completion(planetItems, theError)
      }
    }
  }

}


