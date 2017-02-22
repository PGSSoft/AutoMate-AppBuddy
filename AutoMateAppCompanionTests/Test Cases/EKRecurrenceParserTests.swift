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
        assert(rule: rule, isEqual: ruleDict)
    }

    func testWeeklyRecurrenceRuleParsing() {
        let ruleDict = EKRecurrenceFactory.weeklyRecurenceRule
        var rule: EKRecurrenceRule!
        assertNotThrows(expr: rule = try EKRecurrenceRule.parse(from: ruleDict), "Parsing from \(ruleDict) failed.")
        assert(rule: rule, isEqual: ruleDict)
    }

    func testMonthlyRecurrenceRuleParsing() {
        let ruleDict = EKRecurrenceFactory.monthlyRecurenceRule
        var rule: EKRecurrenceRule!
        assertNotThrows(expr: rule = try EKRecurrenceRule.parse(from: ruleDict), "Parsing from \(ruleDict) failed.")
        assert(rule: rule, isEqual: ruleDict)
    }

    func testYearlyRecurrenceRuleParsing() {
        let ruleDict = EKRecurrenceFactory.yearlyRecurenceRule
        var rule: EKRecurrenceRule!
        assertNotThrows(expr: rule = try EKRecurrenceRule.parse(from: ruleDict), "Parsing from \(ruleDict) failed.")
        assert(rule: rule, isEqual: ruleDict)
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
        assert(recurrenceEnd: recurrenceEnd, isEqual: occurrenceCountRule)
    }

    func testRecurrenceEndByEndDateParsing() {
        let endDateRule = EKRecurrenceFactory.yearlyRecurenceRule
        var recurrenceEnd: EKRecurrenceEnd!
        assertNotThrows(expr: recurrenceEnd = try EKRecurrenceEnd.parse(from: endDateRule), "Parsing \(endDateRule) failed.")
        assert(recurrenceEnd: recurrenceEnd, isEqual: endDateRule)
    }

    // MARK: Helpers
    func assert(rule: EKRecurrenceRule, isEqual expected: [String: Any]) {
        assert(rule.frequency.rawValue, isEqual: expected["frequency"])
        assert(rule.interval, isEqual: expected["interval"])
        assert(array: rule.daysOfTheMonth, isEqual: expected["daysOfTheMonth"])
        assert(array: rule.daysOfTheYear, isEqual: expected["daysOfTheYear"])
        assert(array: rule.monthsOfTheYear, isEqual: expected["monthsOfTheYear"])
        assert(array: rule.weeksOfTheYear, isEqual: expected["weeksOfTheYear"])
        assert(array: rule.setPositions, isEqual: expected["setPositions"])
        assert(countOf: rule.daysOfTheWeek?.map { $0.dayOfTheWeek.rawValue }, isEqual: expected["daysOfTheWeek"])
        XCTAssertEqual(rule.recurrenceEnd != nil, expected["endDate"] != nil || expected["occurrenceCount"] != nil, "\(rule.recurrenceEnd) is not equal to expected \(expected["endDate"]) nor \(expected["occurrenceCount"])")
    }

    func assert(recurrenceEnd: EKRecurrenceEnd, isEqual expected: [String: Any]) {
        assert(recurrenceEnd.occurrenceCount, isEqual: expected["occurrenceCount"] ?? 0)
        assert(recurrenceEnd.endDate, isEqual: date(from: expected["endDate"]))
    }
}
