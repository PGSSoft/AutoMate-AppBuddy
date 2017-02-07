//
//  EventKitParser.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import EventKit

// MARK: - Event Parser
public protocol EventParser: Parser {

    // MARK: Typealiases
    typealias T = EKEvent

    // MARK: Properties
    var eventStore: EKEventStore { get }
    var calendar: EKCalendar { get }
}

// MARK: - Event Dictionary Parser
public struct EventDictionaryParser: EventParser {

    // MARK: Properties
    public var eventStore: EKEventStore
    public var calendar: EKCalendar

    // MARK: Initialization
    public init(with eventStore: EKEventStore, calendar: EKCalendar? = nil) {
        self.eventStore = eventStore
        self.calendar = calendar ?? eventStore.defaultCalendarForNewEvents
    }

    // MARK: Public methods
    public func parse(_ data: Any) throws -> EKEvent {
        guard let jsonDict = data as? [String: Any] else {
            throw ParserError(message: "Expected dictionary, given \(data)")
        }

        let event = EKEvent(eventStore: eventStore)
        event.calendar = calendar
        event.title = try jsonDict.fetch("title")

        let identifier = try jsonDict.fetchOptional("eventIdentifier") { participant(with: $0) }
        event.setValue(identifier, forKey: "eventIdentifier")

        let organizer = try jsonDict.fetchOptional("organizer") { participant(with: $0) }
        event.setValue(organizer, forKey: "organizer")

        event.location = try jsonDict.fetchOptional("location")
        event.notes = try jsonDict.fetchOptional("notes")
        let creationDate = try jsonDict.fetchOptional("creationDate") { date(from: $0) }
        event.setValue(creationDate, forKey: "creationDate")

        let startDate = try jsonDict.fetch("startDate") { date(from: $0) }
        let endDate = try jsonDict.fetch("endDate") { date(from: $0) }
        event.setValuesForKeys([
                                   "startDate": startDate,
                                   "endDate": endDate
                               ])

        let attendees = try jsonDict.fetchArray("attendees") { participant(with: $0) }
        event.setValue(attendees, forKey: "attendees")

        try jsonDict.fetchArray("recurrenceRules", transformation: { $0 })
            .forEach { (object: [String: Any]) in
                let rule = try recurrenceRule(from: object)
                event.addRecurrenceRule(rule)
        }

        return event
    }

    // MARK: Private methods
    private func participant(with name: String?) -> EKParticipant {
        let participant = EKParticipant()
        participant.setValue(name, forKey: "name")
        return participant
    }

    private func date(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd k:mm:ss"
        return dateFormatter.date(from: string)
    }

    private func recurrenceRule(from json: [String: Any]) throws -> EKRecurrenceRule {
        guard let frequency = EKRecurrenceFrequency(rawValue: try json.fetch("frequency")) else {
            preconditionFailure("Couldn't initialize EKRecurrenceFrequency - corrupted value")
        }

        return EKRecurrenceRule(recurrenceWith: frequency,
                                interval: try json.fetch("interval"),
                                daysOfTheWeek: try json.fetchOptional("daysOfTheWeek"),
                                daysOfTheMonth: try json.fetchOptional("daysOfTheMonth"),
                                monthsOfTheYear: try json.fetchOptional("monthsOfTheYear"),
                                weeksOfTheYear: try json.fetchOptional("weeksOfTheYear"),
                                daysOfTheYear: try json.fetchOptional("daysOfTheYear"),
                                setPositions: try json.fetchOptional("setPositions"),
                                end: try recurrenceEnd(with: json))
    }

    private func recurrenceEnd(with json: [String: Any]) throws -> EKRecurrenceEnd? {

        if let endDate = try json.fetchOptional("endDate") { date(from: $0) } {
            return EKRecurrenceEnd(end: endDate)
        } else if let occurrenceCount = try json.fetchOptional("occurrenceCount") as Int? {
            return EKRecurrenceEnd(occurrenceCount: occurrenceCount)
        }

        return nil
    }
}
