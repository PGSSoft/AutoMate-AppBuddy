//
//  EventKitParser.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit

// MARK: - Event Parser
public protocol EventParser: Parser {

    // MARK: Typealiases
    typealias T = EKEvent

    // MARK: Properties
    /// `EKEventStore` in which parsed `EKEvent`s will be created and saved.
    var eventStore: EKEventStore { get }
}

public extension EventParser {

    /// Will access all
    ///
    /// - Parameters:
    ///   - resources: Array of resources describing path to events data.
    ///   - span: _Values for controlling what occurrences to affect in a recurring event._ `.futureEvents` by default.
    /// - Throws: `ParserError` if data has unexpected format or standard `Error` for saving and commiting in EventKit.
    public func parseAndSave(resources: [LaunchEnvironmentResource], with span: EKSpan = .futureEvents) throws {
        try parsed(resources: resources).forEach { try eventStore.save($0, span: span) }
        try eventStore.commit()
    }
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
        try event.parse(from: jsonDict)

        return event
    }
}

// MARK: - Reminder Parser
public protocol ReminderParser: Parser {

    // MARK: Typealiases
    typealias T = EKReminder

    // MARK: Properties
    /// `EKEventStore` in which parsed `EKEvent`s will be created and saved.
    var eventStore: EKEventStore { get }
}

public extension ReminderParser {

    /// Will access all
    ///
    /// - Parameters:
    ///   - resources: Array of resources describing path to reminders data.
    /// - Throws: `ParserError` if data has unexpected format or standard `Error` for saving and commiting in EventKit.
    public func parseAndSave(resources: [LaunchEnvironmentResource]) throws {
        try parsed(resources: resources).forEach { try eventStore.save($0, commit: false) }
        try eventStore.commit()
    }
}

// MARK: - Reminder Dictionary Parser
public struct ReminderDictionaryParser: ReminderParser {

    // MARK: Properties
    public var eventStore: EKEventStore
    public var calendar: EKCalendar

    // MARK: Initialization
    public init(with eventStore: EKEventStore, calendar: EKCalendar? = nil) {
        self.eventStore = eventStore
        self.calendar = calendar ?? eventStore.defaultCalendarForNewEvents
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
