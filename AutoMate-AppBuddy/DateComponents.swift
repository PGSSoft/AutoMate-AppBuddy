//
//  DateComponents.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 14/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

extension DateComponents {

    static func parse(from data: [String: Any]) throws -> DateComponents {
        return DateComponents(calendar: Calendar(identifier: .gregorian),
                              timeZone: try data.fetchOptional("timeZone") { try TimeZone.parse(from: $0) },
                              era: try data.fetchOptional("era"),
                              year: try data.fetchOptional("year"),
                              month: try data.fetchOptional("month"),
                              day: try data.fetchOptional("day"),
                              hour: try data.fetchOptional("hour"),
                              minute: try data.fetchOptional("minute"),
                              second: try data.fetchOptional("second"),
                              nanosecond: try data.fetchOptional("nanosecond"),
                              weekday: try data.fetchOptional("weekday"),
                              weekdayOrdinal: try data.fetchOptional("weekdayOrdinal"),
                              quarter: try data.fetchOptional("quarter"),
                              weekOfMonth: try data.fetchOptional("weekOfMonth"),
                              weekOfYear: try data.fetchOptional("weekOfYear"),
                              yearForWeekOfYear: try data.fetchOptional("yearForWeekOfYear"))
    }

    static func parse(from data: Any) throws -> DateComponents {
        guard let dict = data as? [String: Any] else {
            throw ParserError(message: "Cannot convert \(data) to a `[String: Any]`")
        }
        return try parse(from: dict)
    }
}

extension NSDateComponents {
    static func parse(fromDictionary data: [String: Any]) throws -> NSDateComponents {
        return try DateComponents.parse(from: data) as NSDateComponents
    }

    static func parse(from data: Any) throws -> NSDateComponents {
        return try DateComponents.parse(from: data) as NSDateComponents
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
