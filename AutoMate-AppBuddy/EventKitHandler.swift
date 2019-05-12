//
//  EventKitHandler.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 13/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

#if !os(tvOS)
import EventKit

// MARK: - Event Kit Handler
/// Handles events and reminders by using `EventKit` framework.
///
/// Handler should be added to `LaunchEnvironmentManager`.
///
/// Used key: `AM_EVENTS_KEY`, `AM_REMINDERS_KEY` / `AutoMateLaunchOptionKey.events`, `AutoMateLaunchOptionKey.reminders`.
///
/// Supported values: `LaunchEnvironmentResource` resources representation as a string.
///
/// **Example:**
///
/// ```swift
/// let launchManager = LaunchEnvironmentManager()
/// let eventsHander = EventKitHandler(withParsers: EventDictionaryParser(with: EKEventStore()), ReminderDictionaryParser(with: EKEventStore()),
///                                    eventKitInterface: EventKitInterface())
/// launchManager.add(handler: eventsHander, for: .events)
/// launchManager.add(handler: eventsHander, for: .reminders)
/// launchManager.setup()
/// ```
///
/// - note:
///   `defaultEventKitHander` singleton could be used intead of creating new instance of the `EventKitHandler`.
///
/// - note:
///   Launch environment for the handler can be set by the `EventLaunchEnvironment`
///   and `ReminderLaunchEnvironment` from the [AutoMate](https://github.com/PGSSoft/AutoMate) project.
///
/// - warning:
///   `EventKitHandler` is working only with the `AM_EVENTS_KEY` and `AM_REMINDERS_KEY` key.
///   If any other key will be used handler will throw an exception.
///
/// - seealso: `LaunchEnvironmentManager`
/// - seealso: `LaunchEnvironmentResource`
/// - seealso: `defaultEventKitHander`
public class EventKitHandler<E: EventParser, R: ReminderParser, I: EventKitInterfaceProtocol>: Handler
    where E.T == [String: Any],
        R.T == [String: Any] {

    // MARK: Properties
    /// Events parser, an instance of the `EventParser` protocol.
    public var eventsParser: E
    /// Reminders parser, an instance of the `ReminderParser` protocol.
    public var remindersParser: R
    /// EventKit interface, an instance of the `EventKitInterfaceProtocol` protocol.
    public let eventKitInterface: EventKitInterfaceProtocol
    /// Supported keys. 
    public let keys: [AutoMateLaunchOptionKey] = [.events, .reminders]

    // MARK: Initialization
    /// Initialize this handler with parsers.
    /// `eventsParser` transforms `Dictionary` to `EKEvent`,
    /// `remindersParser` transforms `Dictionary` to `EKReminder`
    /// and interface which is responsible for interacting with `EventKit`.
    ///
    /// - Parameters:
    ///   - eventsParser: Events parser, an instance of type that conforms to the `EventParser` protocol.
    ///     Responsible for transforming `Dictionary` to `EKEvent`.
    ///   - remindersParser: Reminders parser, an instance of type that conforms to the `ReminderParser` protocol.
    ///     Responsible for transforming `Dictionary` to `EKReminder`.
    ///   - eventKitInterface: EventKit interface, an instance of type that conforms to the `EventKitInterfaceProtocol` protocol.
    ///     responsible for interacting with `EventKit`.
    public init(withParsers eventsParser: E, _ remindersParser: R, eventKitInterface: I) {
        self.eventsParser = eventsParser
        self.remindersParser = remindersParser
        self.eventKitInterface = eventKitInterface
    }

    // MARK: Methods
    /// Handles value for the `AM_EVENTS_KEY` and the `AM_REMINDERS_KEY` keys and manage events and reminders.
    ///
    /// - Parameters:
    ///   - key: `AM_EVENTS_KEY`, `AM_REMINDERS_KEY` / `AutoMateLaunchOptionKey.events`, `AutoMateLaunchOptionKey.reminders`.
    ///   - value: `LaunchEnvironmentResource` resources representation as a string.
    public func handle(key: String, value: String) {
        guard let amKey = AutoMateLaunchOptionKey(rawValue: key),
            keys.contains(amKey) else {
                return
        }

        let (resources, cleanFlag) = LaunchEnvironmentResource.resources(from: value)

        switch amKey {
        case .events:
            handle(try? self.eventsParser.parsed(resources: resources),
                   forType: .event,
                   clean: cleanFlag)
        case .reminders:
            handle(try? self.remindersParser.parsed(resources: resources),
                   forType: .reminder,
                   clean: cleanFlag)
        default:
            preconditionFailure("Unknown key \(amKey). If you consider this an issue, please report it at github.com/PGSSoft/AutoMate-AppBuddy.")
        }
    }

    private func handle(_ items: @escaping @autoclosure () -> [EKCalendarItem]?, forType type: EKEntityType, clean: Bool) {
        requestAccessIfNeeded(forType: type) { authorized, error in
            guard authorized, error == nil else {
                preconditionFailure("Access request for type \(type) failed with error \(error?.localizedDescription ?? "access denied").")
            }

            self.cleanCalendars(ifNeeded: clean, ofType: type) { _, error in
                guard error == nil else {
                    preconditionFailure("Clean calendar items of type \(type) failed with error \(error?.localizedDescription ?? "clean failed").")
                }

                self.saveIfNeeded(items(), ofType: type) { saved, error in
                    guard saved, error == nil else {
                        preconditionFailure("Saving calendar items \(String(describing: items())) of type \(type) failed with error \(error?.localizedDescription ?? "saved failed").")
                    }
                }
            }
        }
    }

    private func cleanCalendars(ifNeeded cleanNeeded: Bool, ofType type: EKEntityType, completion: @escaping (Bool, Error?) -> Void) {
        guard cleanNeeded else {
            completion(false, nil)
            return
        }

        eventKitInterface.removeAll(ofType: type, completion: completion)
    }

    private func requestAccessIfNeeded(forType type: EKEntityType, completion: @escaping (Bool, Error?) -> Void) {

        eventKitInterface.requestAccess(forType: type) { authorized, error, eventStore in
            switch type {
            case .event: self.eventsParser.eventStore = eventStore
            case .reminder: self.remindersParser.eventStore = eventStore
            @unknown default:
                preconditionFailure("Unknown type \(type). If you consider this an issue, please report it at https://github.com/PGSSoft/AutoMate-AppBuddy.")
            }
            completion(authorized, error)
        }
    }

    private func saveIfNeeded(_ items: [EKCalendarItem]?, ofType type: EKEntityType, completion: @escaping (Bool, Error?) -> Void) {
        guard let calendarItems = items else {
            completion(false, nil)
            return
        }

        eventKitInterface.addAll(calendarItems, forType: type, completion: completion)
    }
}

// MARK: - Default Event Kit Handler
/// Type of default `EventKitHandler` with all the generic types filled using implementations in the framework.
public typealias DefaultEventKitHander = EventKitHandler<EventDictionaryParser, ReminderDictionaryParser, EventKitInterface>

/// Default `EventKitHandler` with default `EventParser`, `ReminderParser` and `EventKitInterfaceProtocol`.
///
/// **Example:**
///
/// ```swift
/// let launchManager = LaunchEnvironmentManager()
/// launchManager.add(handler: defaultEventKitHander, for: .events)
/// launchManager.add(handler: defaultEventKitHander, for: .reminders)
/// launchManager.setup()
/// ```
///
/// - seealso: `EventKitHandler`
public let defaultEventKitHander: DefaultEventKitHander = EventKitHandler(withParsers: EventDictionaryParser(), ReminderDictionaryParser(),
                                                                          eventKitInterface: EventKitInterface())

#endif
