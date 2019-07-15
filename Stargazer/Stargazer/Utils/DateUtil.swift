//
//  DateUtil.swift
//  Stargazer
//
//  Created by Mihaela MJ on 14/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import Foundation


// 2014-12-09T13:50:51.644000Z

extension ISO8601DateFormatter {
  convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
    self.init()
    self.formatOptions = formatOptions
    self.timeZone = timeZone
  }
}

extension Formatter {
  static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
  var iso8601: String {
    return Formatter.iso8601.string(from: self)
  }
}

extension String {
  var iso8601: Date? {
    return Formatter.iso8601.date(from: self)
  }
}

extension Date {
  var shortUSDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "mm/dd/yy"
    return dateFormatter.string(from: self)
  }
}

//Date().description(with: .current)  //  Tuesday, February 5, 2019 at 10:35:01 PM Brasilia Summer Time"
//let dateString = Date().iso8601   //  "2019-02-06T00:35:01.746Z"
//
//if let date = dateString.iso8601 {
//  date.description(with: .current) // "Tuesday, February 5, 2019 at 10:35:01 PM Brasilia Summer Time"
//  print(date.iso8601)           //  "2019-02-06T00:35:01.746Z\n"
//}

extension JSONDecoder.DateDecodingStrategy {
  static let iso8601withFractionalSeconds = custom {
    let container = try $0.singleValueContainer()
    let string = try container.decode(String.self)
    guard let date = Formatter.iso8601.date(from: string) else {
      throw DecodingError.dataCorruptedError(in: container,
                                             debugDescription: "Invalid date: " + string)
    }
    return date
  }
}

extension JSONEncoder.DateEncodingStrategy {
  static let iso8601withFractionalSeconds = custom {
    var container = $1.singleValueContainer()
    try container.encode(Formatter.iso8601.string(from: $0))
  }
}

//let dates = [Date()]   // ["Feb 8, 2019 at 9:48 PM"]

//encoding

//let encoder = JSONEncoder()
//encoder.dateEncodingStrategy = .iso8601withFractionalSeconds
//let data = try! encoder.encode(dates)
//String(data: data, encoding: .utf8)! // ["2019-02-08T23:46:12.985Z"]\n"

//decoding

//let decoder = JSONDecoder()
//decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
//let decodedDates = try! decoder.decode([Date].self, from: data)  // ["Feb 8, 2019 at 9:48 PM"]
