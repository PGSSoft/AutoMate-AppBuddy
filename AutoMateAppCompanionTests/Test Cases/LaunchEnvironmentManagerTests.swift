//
//  LaunchEnvironmentManagerTests.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 02/02/2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import XCTest
@testable import AutoMateAppCompanion

class LaunchEnvironmentManagerTests: XCTestCase {

    // MARK: Tests
    func testWithEmptyEnviroment() {
        let handler = MockHandler()
        let enviroment: [String: String] = [:]
        let manager = launchEnvironmentManager(withHandlers: [handler], enviroment: enviroment)
        manager.setup()

        assert(nil: handler, in: enviroment)
    }

    func testWithEnviromentForLessHandlersThenAdded() {
        let firstHandler = MockHandler()
        let secondHandler = MockHandler()
        let enviroment = [firstHandler.key: "1st_mocked_value"]
        let manager = launchEnvironmentManager(withHandlers: [firstHandler, secondHandler], enviroment: enviroment)
        manager.setup()

        assert(nil: secondHandler, in: enviroment)
        assert(notNil: firstHandler, in: enviroment)
    }

    func testWithEnviromentAllHandlersAdded() {
        let firstHandler = MockHandler()
        let secondHandler = MockHandler()
        let enviroment = [secondHandler.key: "2nd_mocked_value", firstHandler.key: "1st_mocked_value"]
        let manager = launchEnvironmentManager(withHandlers: [firstHandler, secondHandler], enviroment: enviroment)
        manager.setup()

        assert(notNil: firstHandler, in: enviroment)
        assert(notNil: secondHandler, in: enviroment)
    }

    // MARK: Helpers
    private func launchEnvironmentManager(withHandlers handlers: [MockHandler], enviroment: [String: String]) -> LaunchEnvironmentManager {
        let launchEnvironmentManager = LaunchEnvironmentManager(enviroment: enviroment)
        for handler in handlers {
            launchEnvironmentManager.add(handler: handler, for: handler.key)
        }
        return launchEnvironmentManager
    }

    private func assert(notNil handler: MockHandler, in enviroment: [String: String]) {
        XCTAssertNotNil(handler.received, "Handler with key \(handler.key) wasn't called.")
        XCTAssertEqual(handler.received!.key, handler.key, "Handler with key \(handler.key) called for enviroment with key \(handler.received!.key).")
        XCTAssertEqual(handler.received!.value, enviroment[handler.key]!, "Handler with key \(handler.key) called with value \(handler.received!.value) instead of \(enviroment[handler.key]!).")
    }

    private func assert(nil handler: MockHandler, in enviroment: [String: String]) {
        XCTAssertNil(handler.received, "Handler with key \(handler.key) called for enviroment with key \(handler.received!.key).")
    }
}


