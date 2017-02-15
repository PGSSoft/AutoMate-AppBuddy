//
//  EKReccurrence+Parsers.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 14/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit

extension EKRecurrenceRule {

    static func parse(from json: [String: Any]) throws -> EKRecurrenceRule? {
        guard let frequency = EKRecurrenceFrequency(rawValue: try json.fetch("frequency")) else {
            return nil
        }

        return EKRecurrenceRule(recurrenceWith: frequency,
                                interval: try json.fetch("interval"),
                                daysOfTheWeek: try json.fetchOptionalArray("daysOfTheWeek") { try EKRecurrenceDayOfWeek.from(dayNo: $0) },
                                daysOfTheMonth: try json.fetchOptional("daysOfTheMonth"),
                                monthsOfTheYear: try json.fetchOptional("monthsOfTheYear"),
                                weeksOfTheYear: try json.fetchOptional("weeksOfTheYear"),
                                daysOfTheYear: try json.fetchOptional("daysOfTheYear"),
                                setPositions: try json.fetchOptional("setPositions"),
                                end: try EKRecurrenceEnd.parse(from: json))
    }
}

extension EKRecurrenceDayOfWeek {

    static func from(dayNo: Int) throws -> EKRecurrenceDayOfWeek {
        guard let weekday = EKWeekday(rawValue: dayNo) else {
            throw ParserError(message: "Day \(dayNo) out of range of week.")
        }
        return EKRecurrenceDayOfWeek(weekday)
    }
}

extension EKRecurrenceEnd {

    static func parse(from data: [String: Any]) throws -> EKRecurrenceEnd? {
        if let endDate = try data.fetchOptional("endDate") { Date.from(representation: $0) } {
            return EKRecurrenceEnd(end: endDate)
        } else if let occurrenceCount = try data.fetchOptional("occurrenceCount") as Int? {
            return EKRecurrenceEnd(occurrenceCount: occurrenceCount)
        }

        return nil
    }
}
