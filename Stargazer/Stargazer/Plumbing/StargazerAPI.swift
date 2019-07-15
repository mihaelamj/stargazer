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
    return "\(path)/\(id)"
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

  func fetchAll<T>(id: Int?, completion: @escaping (_ items: [T]?, _ error: Error?) -> Void) where T: Decodable {
    execute(id: id) { data, error in
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
