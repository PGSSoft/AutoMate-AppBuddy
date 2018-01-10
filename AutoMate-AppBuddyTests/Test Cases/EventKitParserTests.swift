//
//  EventKitParserTests.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 06/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
import EventKit
@testable import AutoMate_AppBuddy

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
        assert(event: event, with: eventDict)
    }

    func testParseEventWithRandomInfo() {
        let eventDict = EventFactory.eventDictWithRandomInformations
        var event: EKEvent!
        assertNotThrows(expr: event = try eventDictionaryParser.parse(eventDict), "Parser failed for \(eventDict).")
        assert(event: event, with: eventDict)
    }

    func testParseEventWithAllInfo() {
        let eventDict = EventFactory.eventDictWithAllInformations
        var event: EKEvent!
        assertNotThrows(expr: event = try eventDictionaryParser.parse(eventDict), "Parser failed for \(eventDict).")
        assert(event: event, with: eventDict)
    }

    func testParseEventsFromJSONFile() {
        var events = [EKEvent]()
        let resource = LaunchEnvironmentResource(bundle: "com.pgs-soft.AutoMate-AppBuddyTests", name: "events")!
        assertNotThrows(expr: events = try eventDictionaryParser.parsed(resources: [resource]), "Data format corrupted.")

        XCTAssertEqual(events.count, 3, "Expected 3 events, got \(events.count)")
    }
    
    func testParseReminderWithMinimalInfo() {
        let reminderDict = ReminderFactory.reminderWithMinimalInfo
        var reminder: EKReminder!
        assertNotThrows(expr: reminder = try reminderDictionaryParser.parse(reminderDict), "Parser failed for \(reminderDict).")
        assert(reminder: reminder, with: reminderDict)
    }

    func testParseReminderWithRandomInfo() {
        let reminderDict = ReminderFactory.reminderWithRandomInfo
        var reminder: EKReminder!
        assertNotThrows(expr: reminder = try reminderDictionaryParser.parse(reminderDict), "Parser failed for \(reminderDict).")
        assert(reminder: reminder, with: reminderDict)
    }

    func testParseReminderWithAllInfo() {
        let reminderDict = ReminderFactory.reminderWithAllInfo
        var reminder: EKReminder!
        assertNotThrows(expr: reminder = try reminderDictionaryParser.parse(reminderDict), "Parser failed for \(reminderDict).")
        assert(reminder: reminder, with: reminderDict)
    }

    func testParseRemindersFromJSONFile() {
        var reminders = [EKReminder]()
        let resource = LaunchEnvironmentResource(bundle: "com.pgs-soft.AutoMate-AppBuddyTests", name: "reminders")!
        assertNotThrows(expr: reminders = try reminderDictionaryParser.parsed(resources: [resource]), "Data format corrupted.")

        XCTAssertEqual(reminders.count, 3, "Expected 3 events, got \(reminders.count)")
    }

    // MARK: Helpers
    func assert(calendarItem: EKCalendarItem, with dictionary: [String: Any], file: StaticString = #file, line: UInt = #line) {

        assert(calendarItem.title, isEqual: dictionary["title"], file: file, line: line)
        assert(calendarItem.notes, isEqual: dictionary["notes"], file: file, line: line)
        assert(calendarItem.creationDate, isEqual: date(from: dictionary["creationDate"], file: file, line: line), file: file, line: line)
        assert(countOf: calendarItem.attendees, isEqual: dictionary["attendees"], file: file, line: line)
        assert(countOf: calendarItem.recurrenceRules, isEqual: dictionary["recurrenceRules"], file: file, line: line)
        // Location needs special handling because if set to .none it remains empty String.
        assert(location: calendarItem.location, isEqual: dictionary["location"], file: file, line: line)
        XCTAssertEqual(calendarItem.calendar, calendar, "Event assigned to wrong calendar.", file: file, line: line)
    }

    func assert(event: EKEvent, with dictionary: [String: Any], file: StaticString = #file, line: UInt = #line) {

        assert(calendarItem: event, with: dictionary, file: file, line: line)
        assert(event.startDate, isEqual: date(from: dictionary["startDate"], file: file, line: line), file: file, line: line)
        assert(event.endDate, isEqual: date(from: dictionary["endDate"], file: file, line: line), file: file, line: line)
    }

    func assert(reminder: EKReminder, with dictionary: [String: Any], file: StaticString = #file, line: UInt = #line) {

        assert(calendarItem: reminder, with: dictionary, file: file, line: line)
        assert(reminder.completionDate, isEqual: date(from: dictionary["completionDate"], file: file, line: line), file: file, line: line)
        assert(reminder.isCompleted, isEqual: dictionary["isCompleted"] ?? false, file: file, line: line)
        XCTAssertEqual(reminder.startDateComponents != nil, dictionary["startDateComponents"] != nil, "Expected startDateComponents to be \(dictionary["startDateComponents"].debugDescription) instead of result \(reminder.startDateComponents.debugDescription)", file: file, line: line)
        XCTAssertEqual(reminder.dueDateComponents != nil, dictionary["dueDateComponents"] != nil, "Expected dueDateComponents to be \(dictionary["dueDateComponents"].debugDescription) instead of result \(reminder.dueDateComponents.debugDescription)", file: file, line: line)
    }

    func assert(location argument: String?, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTAssertEqual(argument, "", "Argument is \(argument.debugDescription) while expected is empty.", file: file, line: line)
        case let expectedT as String:
            XCTAssertEqual(expectedT, argument, "Value \(argument.debugDescription) is not equal to \(expectedT.debugDescription)", file: file, line: line)
        default:
            XCTFail("Types \(argument.debugDescription) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    func assert(countOf argument: [EKRecurrenceRule]?, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTAssertNil(argument, "Argument is \(argument.debugDescription) while expected is .none", file: file, line: line)
        case let aCollection as [Any]:
            XCTAssertEqual(aCollection.count, argument?.count, "Value count \(argument?.count ?? 0) is not equal to expected \(aCollection.count).", file: file, line: line)
        case .some:
            XCTFail("Types \(argument.debugDescription) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }
}
