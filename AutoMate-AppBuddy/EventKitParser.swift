//
//  EventKitParser.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit

// MARK: - Event Parser
/// Extension to the `Parser` protocol.
/// Requires the converted object to be an instance of the `EKEvent` type.
///
/// - seealso: `EventDictionaryParser`
/// - seealso: `EventKitHandler`
public protocol EventParser: Parser {

    // MARK: Typealiases
    typealias T = Any
    typealias U = EKEvent

    // MARK: Properties
    /// `EKEventStore` in which parsed `EKEvent`s will be created and saved.
    var eventStore: EKEventStore { get }

}

// MARK: - Event Dictionary Parser
/// Default implementation of the `EventParser` protocol.
///
/// Parse event data from json. Each key from JSON represents property name from the the `EKEvent` type.
///
/// **Example:**
///
/// ```json
/// {
///   "title": "Minimal Event Title",
///   "startDate": "2017-01-22 13:45:00",
///   "endDate": "2017-01-22 14:30:00"
/// }
/// ```
///
/// - seealso: `EventKitHandler`
/// - seealso: For full example check `events.json` file in the test project.
public struct EventDictionaryParser: EventParser {

    // MARK: Properties
    /// Events store used to create and save events.
    public let eventStore: EKEventStore
    /// Calendar in which events will be saved.
    public let calendar: EKCalendar

    // MARK: Initialization
    /// Initialize parser with event store and calendar.
    ///
    /// - Parameters:
    ///   - eventStore: Events store used to create and save events.
    ///   - calendar: Calendar in which events will be saved.
    ///     If `nil`, the `defaultCalendarForNewEvents` will be used.
    public init(with eventStore: EKEventStore, calendar: EKCalendar? = nil) {
        self.eventStore = eventStore
        self.calendar = calendar ?? eventStore.defaultCalendarForNewEvents
    }

    // MARK: Public methods
    /// Parse JSON dictionary (represented as `Any`) and return parsed even object.
    ///
    /// - Parameter data: JSON dictionary to parse.
    /// - Returns: Parsed event.
    /// - Throws: `ParserError` if the provided data are not of a type `[String: Any]`.
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
/// Extension to the `Parser` protocol.
/// Requires the converted object to be an instance of the `EKReminder` type.
///
/// - seealso: `ReminderDictionaryParser`
/// - seealso: `EventKitHandler`
public protocol ReminderParser: Parser {

    // MARK: Typealiases
    typealias T = Any
    typealias U = EKReminder

    // MARK: Properties
    /// `EKEventStore` in which parsed `EKReminder`s will be created and saved.
    var eventStore: EKEventStore { get }
}

// MARK: - Reminder Dictionary Parser
/// Default implementation of the `ReminderParser` protocol.
///
/// Parse reminder data from json. Each key from JSON represents property name from the `EKReminder` type.
///
/// **Example:**
///
/// ```json
/// {
///   "title": "Minimal Reminder Title",
///   "priority": 3
/// }
/// ```
///
/// `DateComponents` is represented as a JSON dictionary:
///
/// **Example:**
///
/// ```json
/// {
///   "startDateComponents": {
///     "timeZone": {
///       "identifier": "America/Los_Angeles",
///     },
///     "year": 2017,
///     "month": 10,
///     "day": 24,
///     "hour": 12,
///     "minute": 25,
///     "second": 0
///   }
/// }
/// ```
///
/// - seealso: `EventKitHandler`
/// - seealso: For full example check `reminders.json` file in the test project.
public struct ReminderDictionaryParser: ReminderParser {

    // MARK: Properties
    /// Events store used to create and save reminders.
    public let eventStore: EKEventStore
    /// Calendar in which reminders will be saved.
    public let calendar: EKCalendar

    // MARK: Initialization
    /// Initialize parser with event store and calendar.
    ///
    /// - Parameters:
    ///   - eventStore: Events store used to create and save reminders.
    ///   - calendar: Calendar in which reminders will be saved.
    ///     If `nil`, the `defaultCalendarForNewReminders()` will be used.
    public init(with eventStore: EKEventStore, calendar: EKCalendar? = nil) {
        self.eventStore = eventStore
        self.calendar = calendar ?? eventStore.defaultCalendarForNewReminders()
    }

    // MARK: Public methods
    /// Parse JSON dictionary (represented as `Any`) and return parsed reminder object.
    ///
    /// - Parameter data: JSON dictionary to parse.
    /// - Returns: Parsed reminder.
    /// - Throws: `ParserError` if the provided data are not of a type `[String: Any]`.
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
