//
//  EventKitHandler.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 13/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit

// MARK: - Event Kit Handler
public struct EventKitHandler<E: EventParser, R: ReminderParser, I: EventKitInterfaceProtocol>: Handler {

    // MARK: Properties
    public let eventsParser: E
    public let remindersParser: R
    public let eventKitInterface: I
    public let keys: [AutoMateLaunchOptionKey] = [.events, .reminders]

    // MARK: Initialization
    public init(withParsers eventsParser: E, _ remindersParser: R, eventKitInterface: I) {
        self.eventsParser = eventsParser
        self.remindersParser = remindersParser
        self.eventKitInterface = eventKitInterface
    }

    // MARK: Methods
    public func handle(key: String, value: String) {
        guard let amKey = AutoMateLaunchOptionKey(rawValue: key),
            keys.contains(amKey) else {
                return
        }

        let (resources, cleanFlag) = LaunchEnvironmentResource.resources(from: value)

        switch amKey {
        case .events:
            let items = (try? self.eventsParser.parsed(resources: resources)) ?? []
            handle(items, forType: .event, clean: cleanFlag)
        case .reminders:
            let items = (try? self.remindersParser.parsed(resources: resources)) ?? []
            handle(items, forType: .reminder, clean: cleanFlag)
        default:
            preconditionFailure("Not supported key")
        }
    }

    private func handle(_ items: [EKCalendarItem], forType type: EKEntityType, clean: Bool) {
        eventKitInterface.requestAccess(forType: .event) { _, _ in
            self.cleanCalendars(ifNeeded: clean, ofType: type) { _, _ in
                self.eventKitInterface.addAll(items, forType: .event, completion: { _, _ in })
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
}

// MARK: - Default Event Kit Handler
public let defaultEventKitHander = EventKitHandler(withParsers: EventDictionaryParser(with: EKEventStore()),
                                                   ReminderDictionaryParser(with: EKEventStore()), eventKitInterface: EventKitInterface())
