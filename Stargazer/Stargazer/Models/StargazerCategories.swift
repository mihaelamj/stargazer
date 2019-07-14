//
//  StargazerCategories.swift
//  Stargazer
//
//  Created by Mihaela MJ on 14/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

//http https://swapi.co/api/people/1/
//http https://swapi.co/api/films/1/
//http https://swapi.co/api/starships/9/
//http https://swapi.co/api/vehicles/4/
//http https://swapi.co/api/species/3/
//http https://swapi.co/api/planets/1/

enum StargazerCategory: String, CaseIterable {
  case people
  case films
  case starships
  case vehicles
  case species
  case planets
}
