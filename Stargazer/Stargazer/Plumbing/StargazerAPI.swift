//
//  StargazerAPI.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

//http https://swapi.co/api/people/1/
//http https://swapi.co/api/films/1/
//http https://swapi.co/api/starships/9/
//http https://swapi.co/api/vehicles/4/
//http https://swapi.co/api/species/3/
//http https://swapi.co/api/planets/1/
//  static let baseURL = "https://swapi.co/api/"

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
    request.timeoutInterval = 5

    //execute request
    sendRequest(request: request) { data, error in
      completion(data, error)
    }
  }
}

// StargazerPerson
// StargazerSpecie
// StargazerFilm
// StargazerStarship
// StargazerVehicle
// StargazerPlanet

enum APIResult<T> {
  case error(Error?)
  case success(T)
}

private extension StargazerCategory {

  func fetchAll<T>(completion: @escaping (_ items: [T]?, _ error: Error?) -> Void) where T: Decodable {
    execute(id: nil) { data, error in
      if let aData = data {
        do {
          let result = try JSONDecoder().decode([T].self, from: aData)
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

extension StargazerCategory {

  static func fetchPeople(completion: @escaping (_ items: [StargazerPerson]?, _ error: Error?) -> Void) {
    StargazerCategory.people.fetchAll { allItems, error in
      completion(allItems, error)
    }
  }

  static func fetchPerson(id: Int, completion: @escaping (_ item: StargazerPerson?, _ error: Error?) -> Void) {
    StargazerCategory.people.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

  static func fetchSpecies(completion: @escaping (_ items: [StargazerSpecie]?, _ error: Error?) -> Void) {
    StargazerCategory.species.fetchAll { allItems, error in
      completion(allItems, error)
    }
  }

  static func fetchSpecie(id: Int, completion: @escaping (_ item: StargazerSpecie?, _ error: Error?) -> Void) {
    StargazerCategory.species.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

  static func fetchFilms(completion: @escaping (_ items: [StargazerFilm]?, _ error: Error?) -> Void) {
    StargazerCategory.films.fetchAll { allItems, error in
      completion(allItems, error)
    }
  }

  static func fetchFilm(id: Int, completion: @escaping (_ item: StargazerFilm?, _ error: Error?) -> Void) {
    StargazerCategory.films.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

  static func fetchStarships(completion: @escaping (_ items: [StargazerStarship]?, _ error: Error?) -> Void) {
    StargazerCategory.starships.fetchAll { allItems, error in
      completion(allItems, error)
    }
  }

  static func fetchStarship(id: Int, completion: @escaping (_ item: StargazerStarship?, _ error: Error?) -> Void) {
    StargazerCategory.starships.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

  static func fetchVehicles(completion: @escaping (_ items: [StargazerVehicle]?, _ error: Error?) -> Void) {
    StargazerCategory.vehicles.fetchAll { allItems, error in
      completion(allItems, error)
    }
  }

  static func fetchVehicle(id: Int, completion: @escaping (_ item: StargazerVehicle?, _ error: Error?) -> Void) {
    StargazerCategory.vehicles.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

  static func fetchPlanets(completion: @escaping (_ items: [StargazerPlanet]?, _ error: Error?) -> Void) {
    StargazerCategory.planets.fetchAll { allItems, error in
      completion(allItems, error)
    }
  }

  static func fetchPlanet(id: Int, completion: @escaping (_ item: StargazerPlanet?, _ error: Error?) -> Void) {
    StargazerCategory.planets.fetchOne(id: id) { oneItem, error in
      completion(oneItem, error)
    }
  }

}

