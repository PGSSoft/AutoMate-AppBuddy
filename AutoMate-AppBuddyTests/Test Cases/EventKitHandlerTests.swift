//
//  EventKitHandlerTests.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 13/03/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
import AutoMate_AppBuddy

fileprivate let eventsKey = AutoMateLaunchOptionKey.events.rawValue
fileprivate let remindersKey = AutoMateLaunchOptionKey.reminders.rawValue

fileprivate let eventsKeyValue = "com.pgs-soft.AutoMate-AppBuddyTests:events"
fileprivate let remindersKeyValue = "com.pgs-soft.AutoMate-AppBuddyTests:reminders"

fileprivate let events = [ EventFactory.mock(), EventFactory.mock()]
fileprivate let reminders = [ ReminderFactory.mock()]

class EventKitHandlerWithoutCleanTests: XCTestCase {

    private static let eventKitInterface = MockEventKitInterface()
    private static var eventKitHandler: EventKitHandler<EventDictionaryParser, ReminderDictionaryParser, MockEventKitInterface>!

    override class func setUp() {
        super.setUp()

        eventKitInterface.events.append(contentsOf: events)
        eventKitInterface.reminders.append(contentsOf: reminders)

        eventKitHandler = EventKitHandler(withParsers: EventDictionaryParser(), ReminderDictionaryParser(), eventKitInterface: eventKitInterface)
        eventKitHandler.handle(key: eventsKey, value: eventsKeyValue)
        eventKitHandler.handle(key: remindersKey, value: remindersKeyValue)
    }

    func testEventsAreSaved() {
        XCTAssertEqual(EventKitHandlerWithoutCleanTests.eventKitInterface.events.count, 5)
    }

    func testRemindersAreSaved() {
        XCTAssertEqual(EventKitHandlerWithoutCleanTests.eventKitInterface.reminders.count, 4)
    }
}

class EventKitHandlerWithCleanTests: XCTestCase {

    private static let eventKitInterface = MockEventKitInterface()
    private static var eventKitHandler: EventKitHandler<EventDictionaryParser, ReminderDictionaryParser, MockEventKitInterface>!

    override class func setUp() {
        super.setUp()

        eventKitInterface.events.append(contentsOf: events)
        eventKitInterface.reminders.append(contentsOf: reminders)

        eventKitHandler = EventKitHandler(withParsers: EventDictionaryParser(), ReminderDictionaryParser(), eventKitInterface: eventKitInterface)
        eventKitHandler.handle(key: eventsKey, value: "AM_CLEAN_DATA_FLAG,\(eventsKeyValue)")
        eventKitHandler.handle(key: remindersKey, value: "AM_CLEAN_DATA_FLAG,\(remindersKeyValue)")
    }

    func testEventsAreSaved() {
        XCTAssertEqual(EventKitHandlerWithCleanTests.eventKitInterface.events.count, 3)
    }

    func testRemindersAreSaved() {
        XCTAssertEqual(EventKitHandlerWithCleanTests.eventKitInterface.reminders.count, 3)
    }
}
