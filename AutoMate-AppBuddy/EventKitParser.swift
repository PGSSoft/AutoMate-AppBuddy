//
//  EventKitParser.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit

// MARK: - Event Parser
public protocol EventParser: Parser {

    // MARK: Typealiases
    typealias T = Any
    typealias U = EKEvent

    // MARK: Properties
    /// `EKEventStore` in which parsed `EKEvent`s will be created and saved.
    var eventStore: EKEventStore { get }

}

// MARK: - Event Dictionary Parser
public struct EventDictionaryParser: EventParser {

    // MARK: Properties
    public let eventStore: EKEventStore
    public let calendar: EKCalendar
    public let span: EKSpan

    // MARK: Initialization
    public init(with eventStore: EKEventStore, calendar: EKCalendar? = nil, span: EKSpan = .futureEvents) {
        self.eventStore = eventStore
        self.calendar = calendar ?? eventStore.defaultCalendarForNewEvents
        self.span = span
    }

    // MARK: Public methods
    public func parse(_ data: Any) throws -> EKEvent {
        guard let jsonDict = data as? [String: Any] else {
            throw ParserError(message: "Expected dictionary, given \(data)")
        }

        let event = EKEvent(eventStore: eventStore)
        event.calendar = calendar
        try event.parse(from: jsonDict)

        return event
    }
}

// MARK: - Reminder Parser
public protocol ReminderParser: Parser {

    // MARK: Typealiases
    typealias T = Any
    typealias U = EKReminder

    // MARK: Properties
    /// `EKEventStore` in which parsed `EKEvent`s will be created and saved.
    var eventStore: EKEventStore { get }
}

// MARK: - Reminder Dictionary Parser
public struct ReminderDictionaryParser: ReminderParser {

    // MARK: Properties
    public let eventStore: EKEventStore
    public let calendar: EKCalendar

    // MARK: Initialization
    public init(with eventStore: EKEventStore, calendar: EKCalendar? = nil) {
        self.eventStore = eventStore
        self.calendar = calendar ?? eventStore.defaultCalendarForNewReminders()
    }

    // MARK: Public methods
    public func parse(_ data: Any) throws -> EKReminder {
        guard let jsonDict = data as? [String: Any] else {
            throw ParserError(message: "Expected dictionary, given \(data)")
        }

        let reminder = EKReminder(eventStore: eventStore)
        reminder.calendar = calendar
        try reminder.parse(from: jsonDict)

        return reminder
    }
}
