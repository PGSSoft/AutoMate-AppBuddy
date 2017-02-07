//
//  EventKitHandler.swift
//  AutoMate - App Companion
//
//  Created by Joanna Bednarz on 13/01/2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import EventKit

// MARK: - Event Kit Handler
public struct EventKitHandler<P: EventParser>: Handler {
    
    // MARK: Properties
    public let parser: P
    public let key: AutoMateLaunchOptionKey = .events

    // MARK: Initialization
    public init(parser: P) {
        self.parser = parser
    }

    // MARK: Methods
    public func handle(key: String, value: String) {
        let resources = LaunchEnviromentResource.resources(from: value)
        try? parser.parsed(resources: resources).forEach { try parser.eventStore.save($0, span: .futureEvents) }
    }
}

// MARK: - Default Event Kit Handler
let defaultEventKitHander = EventKitHandler(parser: EventDictionaryParser(with: EKEventStore()))
