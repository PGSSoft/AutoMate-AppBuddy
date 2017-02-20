//
//  EventKitParserTests.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 06/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
import EventKit
@testable import AutoMateAppCompanion

class EventKitParserTests: XCTestCase {

    // MARK: Properties
    let eventStore = EKEventStore()
    lazy var calendar: EKCalendar = EKCalendar.init(for: .event, eventStore: self.eventStore)
    lazy var eventDictionaryParser: EventDictionaryParser = EventDictionaryParser(with: self.eventStore, calendar: self.calendar)
    lazy var reminderDictionaryParser: ReminderDictionaryParser = ReminderDictionaryParser(with: self.eventStore, calendar: self.calendar)

    // MARK: Tests
    func testParseEventWithMinimalInfo() {
        let eventDict = EventFactory.eventDictWithMinimalInformations
        var event: EKEvent!
        assertNotThrows(expr: event = try eventDictionaryParser.parse(eventDict), "Parser failed for \(eventDict).")
        assert(event, with: eventDict)
    }

    func testParseEventWithRandomInfo() {
        let eventDict = EventFactory.eventDictWithRandomInformations
        var event: EKEvent!
        assertNotThrows(expr: event = try eventDictionaryParser.parse(eventDict), "Parser failed for \(eventDict).")
        assert(event, with: eventDict)
    }

    func testParseEventWithAllInfo() {
        let eventDict = EventFactory.eventDictWithAllInformations
        var event: EKEvent!
        assertNotThrows(expr: event = try eventDictionaryParser.parse(eventDict), "Parser failed for \(eventDict).")
        assert(event, with: eventDict)
    }

    func testParseEventsFromJSONFile() {
        var events = [EKEvent]()
        let resource = LaunchEnvironmentResource(bundle: "com.pgs-soft.AutoMateAppCompanionTests", name: "test_events")!
        assertNotThrows(expr: events = try eventDictionaryParser.parsed(resources: [resource]), "Data format corrupted.")

        XCTAssertEqual(events.count, 3, "Expected 3 events, got \(events.count)")
    }
    func testParseReminderWithMinimalInfo() {
        let reminderDict = ReminderFactory.reminderWithMinimalInfo
        var reminder: EKReminder!
        assertNotThrows(expr: reminder = try reminderDictionaryParser.parse(reminderDict), "Parser failed for \(reminderDict).")
        assert(reminder, with: reminderDict)
    }

    func testParseReminderWithRandomInfo() {
        let reminderDict = ReminderFactory.reminderWithRandomInfo
        var reminder: EKReminder!
        assertNotThrows(expr: reminder = try reminderDictionaryParser.parse(reminderDict), "Parser failed for \(reminderDict).")
        assert(reminder, with: reminderDict)
    }

    func testParseReminderWithAllInfo() {
        let reminderDict = ReminderFactory.reminderWithAllInfo
        var reminder: EKReminder!
        assertNotThrows(expr: reminder = try reminderDictionaryParser.parse(reminderDict), "Parser failed for \(reminderDict).")
        assert(reminder, with: reminderDict)
    }

    func testParseRemindersFromJSONFile() {
        var reminders = [EKReminder]()
        let resource = LaunchEnvironmentResource(bundle: "com.pgs-soft.AutoMateAppCompanionTests", name: "test_reminders")!
        assertNotThrows(expr: reminders = try reminderDictionaryParser.parsed(resources: [resource]), "Data format corrupted.")

        XCTAssertEqual(reminders.count, 3, "Expected 3 events, got \(reminders.count)")
    }

    // MARK: Helpers
    @nonobjc func assert(calendarItem: EKCalendarItem, with dictionary: [String: Any]) {

        assertEqual(calendarItem.title, to: dictionary["title"])
        assertEqual(calendarItem.notes, to: dictionary["notes"])
        assertEqual(calendarItem.creationDate, to: date(from: dictionary["creationDate"]))
        assertCount(of: calendarItem.attendees, isEqual: dictionary["attendees"])
        assertCount(of: calendarItem.recurrenceRules, isEqual: dictionary["recurrenceRules"])
        // Location needs special handling because if set to .none it remains empty String.
        assertLocation(calendarItem.location, isEqual: dictionary["location"])
        XCTAssertEqual(calendarItem.calendar, calendar, "Event assigned to wrong calendar.")
    }

    @nonobjc func assert(_ event: EKEvent, with dictionary: [String: Any]) {

        assert(calendarItem: event, with: dictionary)
        assertEqual(event.startDate, to: date(from: dictionary["startDate"]))
        assertEqual(event.endDate, to: date(from: dictionary["endDate"]))
    }

    @nonobjc func assert(_ reminder: EKReminder, with dictionary: [String: Any]) {

        assert(calendarItem: reminder, with: dictionary)
        assertEqual(reminder.completionDate, to: date(from: dictionary["completionDate"]))
        assertEqual(reminder.isCompleted, to: dictionary["isCompleted"] ?? false)
        XCTAssertEqual(reminder.startDateComponents != nil, dictionary["startDateComponents"] != nil, "Expected startDateComponents to be \(dictionary["startDateComponents"]) instead of result \(reminder.startDateComponents)")
        XCTAssertEqual(reminder.dueDateComponents != nil, dictionary["dueDateComponents"] != nil, "Expected dueDateComponents to be \(dictionary["dueDateComponents"]) instead of result \(reminder.dueDateComponents)")
    }

    func assertLocation(_ argument: String?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertEqual(argument, "", "Argument is \(argument) while expected is empty.")
        case let expectedT as String:
            XCTAssertEqual(expectedT, argument, "Value \(argument) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(argument) and \(expected) do not match.")
        }
    }

    func assertCount(of argument: [EKRecurrenceRule]?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertEqual(argument?.count, 0, "Argument is \(argument) while expected is .none")
        case let aCollection as [Any]:
            XCTAssertEqual(aCollection.count, argument?.count, "Value count \(argument?.count) is not equal to expected \(aCollection.count).")
        case .some:
            XCTFail("Types \(argument) and \(expected) do not match.")
        }
    }
}
