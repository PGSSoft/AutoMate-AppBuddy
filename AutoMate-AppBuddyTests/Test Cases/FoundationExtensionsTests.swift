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

        var dc: DateComponents!
        assertNotThrows(expr: try dc = DateComponents.parse(from: data), "Cannot create DateComponents")
        XCTAssertNotNil(dc.calendar)
        XCTAssertNil(dc.timeZone)
        XCTAssertEqual(dc.date, DateComponents.init(calendar: Calendar(identifier: .gregorian)).date)

        XCTAssertNil(dc.era)
        XCTAssertFalse(dc.isLeapMonth!)
        XCTAssertNil(dc.quarter)
        XCTAssertNil(dc.weekOfMonth)
        XCTAssertNil(dc.weekOfYear)
        XCTAssertNil(dc.weekday)
        XCTAssertNil(dc.weekdayOrdinal)
        XCTAssertNil(dc.yearForWeekOfYear)
        XCTAssertNil(dc.year)
        XCTAssertNil(dc.month)
        XCTAssertNil(dc.day)
        XCTAssertNil(dc.hour)
        XCTAssertNil(dc.minute)
        XCTAssertNil(dc.second)
        XCTAssertNil(dc.nanosecond)
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

        var dc: DateComponents!
        assertNotThrows(expr: try dc = DateComponents.parse(from: data), "Cannot create DateComponents")
        XCTAssertNotNil(dc.calendar)
        XCTAssertEqual(dc.timeZone, TimeZone(secondsFromGMT: 3000))
        XCTAssertEqual(dc.date, Date(timeIntervalSinceReferenceDate: -63050662800.0))

        XCTAssertEqual(dc.era, 1)
        XCTAssertFalse(dc.isLeapMonth!)
        XCTAssertEqual(dc.quarter, 2)
        XCTAssertEqual(dc.weekOfMonth, 3)
        XCTAssertEqual(dc.weekOfYear, 5)
        XCTAssertEqual(dc.weekday, 6)
        XCTAssertEqual(dc.weekdayOrdinal, 2)
        XCTAssertEqual(dc.yearForWeekOfYear, 3)
        XCTAssertEqual(dc.year, 2018)
        XCTAssertEqual(dc.month, 1)
        XCTAssertEqual(dc.day, 2)
        XCTAssertEqual(dc.hour, 23)
        XCTAssertEqual(dc.minute, 50)
        XCTAssertEqual(dc.second, 0)
        XCTAssertNil(dc.nanosecond)
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

        var dc: DateComponents!
        assertNotThrows(expr: try dc = DateComponents.parse(from: data), "Cannot create DateComponents")
        XCTAssertNotNil(dc.calendar)
        XCTAssertEqual(dc.timeZone, TimeZone(identifier: "America/Los_Angeles"))
        XCTAssertEqual(dc.date, Date(timeIntervalSinceReferenceDate: 530521200.0))

        XCTAssertNil(dc.era)
        XCTAssertFalse(dc.isLeapMonth!)
        XCTAssertNil(dc.quarter)
        XCTAssertNil(dc.weekOfMonth)
        XCTAssertNil(dc.weekOfYear)
        XCTAssertNil(dc.weekday)
        XCTAssertNil(dc.weekdayOrdinal)
        XCTAssertNil(dc.yearForWeekOfYear)
        XCTAssertEqual(dc.year, 2017)
        XCTAssertEqual(dc.month, 10)
        XCTAssertEqual(dc.day, 24)
        XCTAssertNil(dc.hour)
        XCTAssertNil(dc.minute)
        XCTAssertNil(dc.second)
        XCTAssertNil(dc.nanosecond)
    }
}
