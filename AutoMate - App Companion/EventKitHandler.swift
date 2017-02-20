//
//  EventKitHandler.swift
//  AutoMate - App Companion
//
//  Created by Joanna Bednarz on 13/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit

// MARK: - Event Kit Handler
public struct EventKitHandler<E: EventParser, R: ReminderParser>: Handler {

    // MARK: Properties
    public let eventsParser: E
    public let remindersParser: R
    public let keys: [AutoMateLaunchOptionKey] = [.events, .reminders]

    // MARK: Initialization
    public init(withParsers eventsParser: E, _ remindersParser: R) {
        self.eventsParser = eventsParser
        self.remindersParser = remindersParser
    }

    // MARK: Methods
    public func handle(key: String, value: String) {
        guard let amKey = AutoMateLaunchOptionKey(rawValue: key),
            keys.contains(amKey) else {
                return
        }
        let resources = LaunchEnvironmentResource.resources(from: value)
        switch amKey {
        case .events:
            try? eventsParser.parseAndSave(resources: resources)
        case .reminders:
            try? remindersParser.parseAndSave(resources: resources)
        default:
            preconditionFailure("Not supported key")
        }
    }
}

// MARK: - Default Event Kit Handler
public let defaultEventKitHander = EventKitHandler(withParsers: EventDictionaryParser(with: EKEventStore()),
                                                   ReminderDictionaryParser(with: EKEventStore()))
