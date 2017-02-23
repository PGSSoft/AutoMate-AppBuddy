//
//  EventKit+Parsers.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 14/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit

extension EKCalendarItem {

    func parse(from data: [String: Any]) throws {
        let creationDate = try data.fetchOptional("creationDate") { Date.from(representation: $0) }
        let recurrenceRules = try data.fetchOptionalArray("recurrenceRules") { try EKRecurrenceRule.parse(from: $0) }

        self.title = try data.fetch("title")
        self.location = try data.fetchOptional("location")
        self.notes = try data.fetchOptional("notes")
        setValue(creationDate, forKey: #keyPath(EKEvent.creationDate))
        recurrenceRules?.forEach { addRecurrenceRule($0) }
    }
}

extension EKEvent {

    override func parse(from data: [String: Any]) throws {
        try super.parse(from: data)

        let startDate = try data.fetch("startDate") { Date.from(representation: $0) }
        let endDate = try data.fetch("endDate") { Date.from(representation: $0) }

        setValuesForKeys([
                             #keyPath(EKEvent.startDate): startDate,
                             #keyPath(EKEvent.endDate): endDate
                         ])
    }
}

extension EKReminder {

    override func parse(from data: [String: Any]) throws {
        try super.parse(from: data)

        startDateComponents = try data.fetchOptional("startDateComponents") { try DateComponents.parse(from: $0) }
        dueDateComponents = try data.fetchOptional("dueDateComponents") { try DateComponents.parse(from: $0) }
        isCompleted = try data.fetchOptional("isCompleted") ?? false
        priority = try data.fetch("priority")
        completionDate = try data.fetchOptional("completionDate") { Date.from(representation: $0) }
    }
}
