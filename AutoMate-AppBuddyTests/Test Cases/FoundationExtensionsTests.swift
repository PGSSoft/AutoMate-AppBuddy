//
//  FoundationExtensionsTests.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 09.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
@testable import AutoMate_AppBuddy

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

    func testDateComponentsParsing01() {
        let data: [String: Any] = [:]

        var dateComponents: DateComponents!
        assertNotThrows(expr: try dateComponents = DateComponents.parse(from: data), "Cannot create DateComponents")
        XCTAssertNotNil(dateComponents.calendar)
        XCTAssertNil(dateComponents.timeZone)
        XCTAssertEqual(dateComponents.date, DateComponents.init(calendar: Calendar(identifier: .gregorian)).date)

        XCTAssertNil(dateComponents.era)
        XCTAssertFalse(dateComponents.isLeapMonth!)
        XCTAssertNil(dateComponents.quarter)
        XCTAssertNil(dateComponents.weekOfMonth)
        XCTAssertNil(dateComponents.weekOfYear)
        XCTAssertNil(dateComponents.weekday)
        XCTAssertNil(dateComponents.weekdayOrdinal)
        XCTAssertNil(dateComponents.yearForWeekOfYear)
        XCTAssertNil(dateComponents.year)
        XCTAssertNil(dateComponents.month)
        XCTAssertNil(dateComponents.day)
        XCTAssertNil(dateComponents.hour)
        XCTAssertNil(dateComponents.minute)
        XCTAssertNil(dateComponents.second)
        XCTAssertNil(dateComponents.nanosecond)
    }

    func testDateComponentsParsing02() {
        let data: [String: Any] = [
            "timeZone": [
                "secondsFromGMT": 3000
            ],
            "era": 1,
            "quarter": 2,
            "weekOfMonth": 3,
            "weekOfYear": 5,
            "weekday": 6,
            "weekdayOrdinal": 2,
            "yearForWeekOfYear": 3,
            "year": 2018,
            "month": 1,
            "day": 2,
            "hour": 23,
            "minute": 50,
            "second": 0
        ]

        var dateComponents: DateComponents!
        assertNotThrows(expr: try dateComponents = DateComponents.parse(from: data), "Cannot create DateComponents")
        XCTAssertNotNil(dateComponents.calendar)
        XCTAssertEqual(dateComponents.timeZone, TimeZone(secondsFromGMT: 3000))
        XCTAssertEqual(dateComponents.date, Date(timeIntervalSince1970: -62072528400))

        XCTAssertEqual(dateComponents.era, 1)
        XCTAssertFalse(dateComponents.isLeapMonth!)
        XCTAssertEqual(dateComponents.quarter, 2)
        XCTAssertEqual(dateComponents.weekOfMonth, 3)
        XCTAssertEqual(dateComponents.weekOfYear, 5)
        XCTAssertEqual(dateComponents.weekday, 6)
        XCTAssertEqual(dateComponents.weekdayOrdinal, 2)
        XCTAssertEqual(dateComponents.yearForWeekOfYear, 3)
        XCTAssertEqual(dateComponents.year, 2018)
        XCTAssertEqual(dateComponents.month, 1)
        XCTAssertEqual(dateComponents.day, 2)
        XCTAssertEqual(dateComponents.hour, 23)
        XCTAssertEqual(dateComponents.minute, 50)
        XCTAssertEqual(dateComponents.second, 0)
        XCTAssertNil(dateComponents.nanosecond)
    }

    func testDateComponentsParsing03() {
        let data: [String: Any] = [
            "timeZone": [
                "identifier": "America/Los_Angeles"
            ],
            "year": 2017,
            "month": 10,
            "day": 24
        ]

        var dateComponents: DateComponents!
        assertNotThrows(expr: try dateComponents = DateComponents.parse(from: data), "Cannot create DateComponents")
        XCTAssertNotNil(dateComponents.calendar)
        XCTAssertEqual(dateComponents.timeZone, TimeZone(identifier: "America/Los_Angeles"))
        XCTAssertEqual(dateComponents.date, Date(timeIntervalSinceReferenceDate: 530521200.0))

        XCTAssertNil(dateComponents.era)
        XCTAssertFalse(dateComponents.isLeapMonth!)
        XCTAssertNil(dateComponents.quarter)
        XCTAssertNil(dateComponents.weekOfMonth)
        XCTAssertNil(dateComponents.weekOfYear)
        XCTAssertNil(dateComponents.weekday)
        XCTAssertNil(dateComponents.weekdayOrdinal)
        XCTAssertNil(dateComponents.yearForWeekOfYear)
        XCTAssertEqual(dateComponents.year, 2017)
        XCTAssertEqual(dateComponents.month, 10)
        XCTAssertEqual(dateComponents.day, 24)
        XCTAssertNil(dateComponents.hour)
        XCTAssertNil(dateComponents.minute)
        XCTAssertNil(dateComponents.second)
        XCTAssertNil(dateComponents.nanosecond)
    }
}
