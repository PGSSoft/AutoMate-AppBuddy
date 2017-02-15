//
//  DateComponents.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 14/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

extension DateComponents {

    static func parse(from data: [String: Any]) throws -> DateComponents {
        return DateComponents(calendar: Calendar(identifier: .gregorian),
                              timeZone: try data.fetchOptional("timeZone") { try TimeZone.parse(from: $0) },
                              year: try data.fetchOptional("year"),
                              month: try data.fetchOptional("month"),
                              day: try data.fetchOptional("day"),
                              hour: try data.fetchOptional("hour"),
                              minute: try data.fetchOptional("minute"),
                              second: try data.fetchOptional("second"))
    }
}

extension TimeZone {
    static func parse(from data: [String: Any]) throws -> TimeZone? {
        if let abbreviation: String = try data.fetchOptional("abbreviation") {
            return TimeZone(abbreviation: abbreviation)
        }
        if let identifier: String = try data.fetchOptional("identifier") {
            return TimeZone(identifier: identifier)
        }
        if let secondsFromGMT: Int = try data.fetchOptional("secondsFromGMT") {
            return TimeZone(secondsFromGMT: secondsFromGMT)
        }

        return nil
    }
}
