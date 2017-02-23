//
//  LaunchEnvironmentManagerTests.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 02/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
@testable import AutoMate_AppBuddy

class LaunchEnvironmentManagerTests: XCTestCase {

    // MARK: Tests
    func testWithEmptyEnvironment() {
        let handler = MockHandler()
        let environment: [String: String] = [:]
        let manager = launchEnvironmentManager(withHandlers: [handler], environment: environment)
        manager.setup()

        assert(nil: handler, in: environment)
    }

    func testWithEnvironmentForLessHandlersThenAdded() {
        let firstHandler = MockHandler()
        let secondHandler = MockHandler()
        let environment = [firstHandler.key: "1st_mocked_value"]
        let manager = launchEnvironmentManager(withHandlers: [firstHandler, secondHandler], environment: environment)
        manager.setup()

        assert(nil: secondHandler, in: environment)
        assert(notNil: firstHandler, in: environment)
    }

    func testWithEnvironmentAllHandlersAdded() {
        let firstHandler = MockHandler()
        let secondHandler = MockHandler()
        let environment = [secondHandler.key: "2nd_mocked_value", firstHandler.key: "1st_mocked_value"]
        let manager = launchEnvironmentManager(withHandlers: [firstHandler, secondHandler], environment: environment)
        manager.setup()

        assert(notNil: firstHandler, in: environment)
        assert(notNil: secondHandler, in: environment)
    }

    func testWithEventKitEnvironmentOptions() {
        let eventsParser = MockEventsParser()
        let remindersParser = MockRemindersParser()
        let eventKitHandler = EventKitHandler(withParsers: eventsParser, remindersParser)
        let testBundleName = "com.pgs-soft.AutoMate-AppBuddyTests"
        let environment = [AutoMateLaunchOptionKey.events.rawValue: "\(testBundleName):events", AutoMateLaunchOptionKey.reminders.rawValue: "\(testBundleName):reminders"]

        let launchEnvironmentManager = LaunchEnvironmentManager(environment: environment)
        launchEnvironmentManager.add(handler: eventKitHandler, for: .events)
        launchEnvironmentManager.add(handler: eventKitHandler, for: .reminders)
        launchEnvironmentManager.setup()

        XCTAssertNotNil(eventsParser.dataRecived)
        XCTAssertEqual(eventsParser.dataRecived.count, 3)
        XCTAssertEqual(remindersParser.dataRecived.count, 3)
    }

    func testWithContactsEnvironmentOptions() {
        let contactParser = MockContactsParser()
        let contactsHandler = ContactsHandler(withParser: contactParser)
        let testBundleName = "com.pgs-soft.AutoMate-AppBuddyTests"
        let environment = [AutoMateLaunchOptionKey.contacts.rawValue: "\(testBundleName):contacts"]

        let launchEnvironmentManager = LaunchEnvironmentManager(environment: environment)
        launchEnvironmentManager.add(handler: contactsHandler, for: .contacts)
        launchEnvironmentManager.setup()

        XCTAssertNotNil(contactParser.dataRecived)
        XCTAssertEqual(contactParser.dataRecived.count, 2)
    }

    // MARK: Helpers
    private func launchEnvironmentManager(withHandlers handlers: [MockHandler], environment: [String: String]) -> LaunchEnvironmentManager {
        let launchEnvironmentManager = LaunchEnvironmentManager(environment: environment)
        for handler in handlers {
            launchEnvironmentManager.add(handler: handler, for: handler.key)
        }
        return launchEnvironmentManager
    }

    private func assert(notNil handler: MockHandler, in environment: [String: String]) {
        XCTAssertNotNil(handler.received, "Handler with key \(handler.key) wasn't called.")
        XCTAssertEqual(handler.received!.key, handler.key, "Handler with key \(handler.key) called for environment with key \(handler.received!.key).")
        XCTAssertEqual(handler.received!.value, environment[handler.key]!, "Handler with key \(handler.key) called with value \(handler.received!.value) instead of \(environment[handler.key]!).")
    }

    private func assert(nil handler: MockHandler, in environment: [String: String]) {
        XCTAssertNil(handler.received, "Handler with key \(handler.key) called for environment with key \(handler.received!.key).")
    }
}
