//
//  StargazerCategoryItem.swift
//  Stargazer
//
//  Created by Mihaela MJ on 14/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation

// MARK: -
// MARK: Model Adapter -

struct StargazerCategoryItemListAdapter {
  var initials: String?
  var title: String?
  var subtitle: String?
  var dateCreated: String?
  var category: StargazerCategory?

  init(initials: String, title: String, subtitle: String, dateCreated: String, category: StargazerCategory) {
    self.initials = initials
    self.title = title
    self.subtitle = subtitle
    self.dateCreated = dateCreated
    self.category = category
  }
}

protocol StargazerCategoryItemListAdapterProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter
}

// MARK: -
// MARK: Adapters -

// StargazerPerson
// StargazerSpecie
// StargazerFilm
// StargazerStarship
// StargazerVehicle
// StargazerPlanet

extension StargazerPerson: StargazerCategoryItemListAdapterProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let title = name ?? "n/a"
    let subtitle = birthYear ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: title, subtitle: subtitle, dateCreated: date, category: .people)
  }
}

extension StargazerSpecie: StargazerCategoryItemListAdapterProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let title = name ?? "n/a"
    let subtitle = classification ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: title, subtitle: subtitle, dateCreated: date, category: .species)
  }
}

extension StargazerFilm: StargazerCategoryItemListAdapterProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = title?.initials(2) ?? ""
    let aTitle = title ?? "n/a"
    let subtitle = openingCrawl ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: aTitle, subtitle: subtitle, dateCreated: date, category: .films)
  }
}

extension StargazerStarship: StargazerCategoryItemListAdapterProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let aTitle = name ?? "n/a"
    let subtitle = vessel?.model ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: aTitle, subtitle: subtitle, dateCreated: date, category: .films)
  }
}

extension StargazerVehicle: StargazerCategoryItemListAdapterProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let aTitle = name ?? "n/a"
    let subtitle = vessel?.model ?? "n/a"
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: aTitle, subtitle: subtitle, dateCreated: date, category: .films)
  }
}

extension StargazerPlanet: StargazerCategoryItemListAdapterProtocol {
  func asStargazerCategoryItem() -> StargazerCategoryItemListAdapter {
    let initials = name?.initials(2) ?? ""
    let aTitle = name ?? "n/a"
    var subtitle = "n/a"; if let aDieametar = diameter { subtitle = String(aDieametar) }
    let date = created?.shortUSDate ?? "n/a"
    return StargazerCategoryItemListAdapter(initials: initials, title: aTitle, subtitle: subtitle, dateCreated: date, category: .films)
  }
}
