//
//  EKRecurrenceParserTests.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 15/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
import EventKit
@testable import AutoMateAppCompanion

class EKRecurrenceParserTests: XCTestCase {

    // MARK: Tests
    func testDailyRecurrenceRuleParsing() {
        let ruleDict = EKRecurrenceFactory.dailyRecurenceRule
        var rule: EKRecurrenceRule!
        assertNotThrows(expr: rule = try EKRecurrenceRule.parse(from: ruleDict), "Parsing from \(ruleDict) failed.")
        assert(rule, isEqual: ruleDict)
    }

    func testWeeklyRecurrenceRuleParsing() {
        let ruleDict = EKRecurrenceFactory.weeklyRecurenceRule
        var rule: EKRecurrenceRule!
        assertNotThrows(expr: rule = try EKRecurrenceRule.parse(from: ruleDict), "Parsing from \(ruleDict) failed.")
        assert(rule, isEqual: ruleDict)
    }

    func testMonthlyRecurrenceRuleParsing() {
        let ruleDict = EKRecurrenceFactory.monthlyRecurenceRule
        var rule: EKRecurrenceRule!
        assertNotThrows(expr: rule = try EKRecurrenceRule.parse(from: ruleDict), "Parsing from \(ruleDict) failed.")
        assert(rule, isEqual: ruleDict)
    }

    func testYearlyRecurrenceRuleParsing() {
        let ruleDict = EKRecurrenceFactory.yearlyRecurenceRule
        var rule: EKRecurrenceRule!
        assertNotThrows(expr: rule = try EKRecurrenceRule.parse(from: ruleDict), "Parsing from \(ruleDict) failed.")
        assert(rule, isEqual: ruleDict)
    }

    func testRecurrenceDayOfWeekParsing() {
        let weekdayNumber = 4
        var weekday: EKRecurrenceDayOfWeek!
        assertNotThrows(expr: weekday = try EKRecurrenceDayOfWeek.from(dayNo: weekdayNumber), "")
        XCTAssertEqual(weekday.dayOfTheWeek.rawValue, weekdayNumber, "Weekday no \(weekday.dayOfTheWeek) is not equal to expected \(weekdayNumber).")
    }

    func testRecurrenceEndByOccurrenceCountParsing() {
        let occurrenceCountRule = EKRecurrenceFactory.monthlyRecurenceRule
        var recurrenceEnd: EKRecurrenceEnd!
        assertNotThrows(expr: recurrenceEnd = try EKRecurrenceEnd.parse(from: occurrenceCountRule), "Parsing \(occurrenceCountRule) failed.")
        assert(recurrenceEnd, isEqual: occurrenceCountRule)
    }

    func testRecurrenceEndByEndDateParsing() {
        let endDateRule = EKRecurrenceFactory.yearlyRecurenceRule
        var recurrenceEnd: EKRecurrenceEnd!
        assertNotThrows(expr: recurrenceEnd = try EKRecurrenceEnd.parse(from: endDateRule), "Parsing \(endDateRule) failed.")
        assert(recurrenceEnd, isEqual: endDateRule)
    }

    // MARK: Helpers
    @nonobjc func assert(_ rule: EKRecurrenceRule, isEqual expected: [String: Any]) {
        assertEqual(rule.frequency.rawValue, to: expected["frequency"])
        assertEqual(rule.interval, to: expected["interval"])
        assertEqual(array: rule.daysOfTheMonth, to: expected["daysOfTheMonth"])
        assertEqual(array: rule.daysOfTheYear, to: expected["daysOfTheYear"])
        assertEqual(array: rule.monthsOfTheYear, to: expected["monthsOfTheYear"])
        assertEqual(array: rule.weeksOfTheYear, to: expected["weeksOfTheYear"])
        assertEqual(array: rule.setPositions, to: expected["setPositions"])
        assertCount(of: rule.daysOfTheWeek?.map { $0.dayOfTheWeek.rawValue }, isEqual: expected["daysOfTheWeek"])
        XCTAssertEqual(rule.recurrenceEnd != nil, expected["endDate"] != nil || expected["occurrenceCount"] != nil, "\(rule.recurrenceEnd) is not equal to expected \(expected["endDate"]) nor \(expected["occurrenceCount"])")
    }

    @nonobjc func assert(_ recurrenceEnd: EKRecurrenceEnd, isEqual expected: [String: Any]) {
        assertEqual(recurrenceEnd.occurrenceCount, to: expected["occurrenceCount"] ?? 0)
        assertEqual(recurrenceEnd.endDate, to: date(from: expected["endDate"]))
    }
}
