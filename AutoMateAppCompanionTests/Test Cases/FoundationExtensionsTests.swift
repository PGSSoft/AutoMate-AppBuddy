//
//  FoundationExtensionsTests.swift
//  AutoMate App Companion
//
//  Created by Bartosz Janda on 09.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
@testable import AutoMateAppCompanion

class FoundationExtensionsTests: XCTestCase {

    // MARK: Tests
    func testStringBoolValue() {
        XCTAssertEqual("true".boolValue, true)
        XCTAssertEqual("TRUE".boolValue, true)
        XCTAssertEqual("True".boolValue, true)
        XCTAssertEqual("yes".boolValue, true)
        XCTAssertEqual("YES".boolValue, true)
        XCTAssertEqual("Yes".boolValue, true)
        XCTAssertEqual("1".boolValue, true)

        XCTAssertEqual("false".boolValue, false)
        XCTAssertEqual("FALSE".boolValue, false)
        XCTAssertEqual("False".boolValue, false)
        XCTAssertEqual("no".boolValue, false)
        XCTAssertEqual("NO".boolValue, false)
        XCTAssertEqual("No".boolValue, false)
        XCTAssertEqual("0".boolValue, false)

        XCTAssertNil("".boolValue)
        XCTAssertNil(" ".boolValue)
        XCTAssertNil("a".boolValue)
        XCTAssertNil("_".boolValue)
    }
}
