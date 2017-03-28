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
    func assert(calendarItem: EKCalendarItem, with dictionary: [String: Any]) {

        assert(calendarItem.title, isEqual: dictionary["title"])
        assert(calendarItem.notes, isEqual: dictionary["notes"])
        assert(calendarItem.creationDate, isEqual: date(from: dictionary["creationDate"]))
        assert(countOf: calendarItem.attendees, isEqual: dictionary["attendees"])
        assert(countOf: calendarItem.recurrenceRules, isEqual: dictionary["recurrenceRules"])
        // Location needs special handling because if set to .none it remains empty String.
        assert(location: calendarItem.location, isEqual: dictionary["location"])
        XCTAssertEqual(calendarItem.calendar, calendar, "Event assigned to wrong calendar.")
    }

    func assert(event: EKEvent, with dictionary: [String: Any]) {

        assert(calendarItem: event, with: dictionary)
        assert(event.startDate, isEqual: date(from: dictionary["startDate"]))
        assert(event.endDate, isEqual: date(from: dictionary["endDate"]))
    }

    func assert(reminder: EKReminder, with dictionary: [String: Any]) {

        assert(calendarItem: reminder, with: dictionary)
        assert(reminder.completionDate, isEqual: date(from: dictionary["completionDate"]))
        assert(reminder.isCompleted, isEqual: dictionary["isCompleted"] ?? false)
        XCTAssertEqual(reminder.startDateComponents != nil, dictionary["startDateComponents"] != nil, "Expected startDateComponents to be \(String(describing: dictionary["startDateComponents"])) instead of result \(String(describing: reminder.startDateComponents))")
        XCTAssertEqual(reminder.dueDateComponents != nil, dictionary["dueDateComponents"] != nil, "Expected dueDateComponents to be \(String(describing: dictionary["dueDateComponents"])) instead of result \(String(describing: reminder.dueDateComponents))")
    }

    func assert(location argument: String?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertEqual(argument, "", "Argument is \(String(describing: argument)) while expected is empty.")
        case let expectedT as String:
            XCTAssertEqual(expectedT, argument, "Value \(String(describing: argument)) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(String(describing: argument)) and \(String(describing: expected)) do not match.")
        }
    }

    func assert(countOf argument: [EKRecurrenceRule]?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertEqual(argument?.count, 0, "Argument is \(String(describing: argument)) while expected is .none")
        case let aCollection as [Any]:
            XCTAssertEqual(aCollection.count, argument?.count, "Value count \(String(describing: argument?.count)) is not equal to expected \(aCollection.count).")
        case .some:
            XCTFail("Types \(String(describing: argument)) and \(String(describing: expected)) do not match.")
        }
    }
}
