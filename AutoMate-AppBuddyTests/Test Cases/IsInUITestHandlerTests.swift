//
//  IsInUITestHandlerTests.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda (PGS Software) on 29.06.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
import AutoMate_AppBuddy

class IsInUITestHandlerTests: XCTestCase {

    // MARK: Properties
    var isInUITestHandler: IsInUITestHandler!

    // MARK: Setup
    override func setUp() {
        super.setUp()
        isInUITestHandler = IsInUITestHandler()
        UIView.setAnimationsEnabled(true)
    }

    override func tearDown() {
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    // MARK: Tests
    func testInUiTest() {
        isInUITestHandler.handle(key: AutoMateLaunchOptionKey.isInUITest.rawValue, value: "true")
        XCTAssertTrue(isInUITestHandler.inUITest)
    }

    func testNotInUiTest() {
        isInUITestHandler.handle(key: AutoMateLaunchOptionKey.isInUITest.rawValue, value: "false")
        XCTAssertFalse(isInUITestHandler.inUITest)
    }
}
