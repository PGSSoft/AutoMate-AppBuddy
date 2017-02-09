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
    lazy var dictionaryParser: EventDictionaryParser = EventDictionaryParser(with: self.eventStore, calendar: self.calendar)

    // MARK: Tests
    func testParseEventWithMinimalInfo() {
        let eventDict = EventFactory.eventWithMinimalInformations
        var event: EKEvent!
        assertNotThrows(expr: event = try dictionaryParser.parse(eventDict), "Parser failed for \(eventDict).")
        assert(event, with: eventDict)
    }

    func testParseEventWithRandomInfo() {
        let eventDict = EventFactory.eventWithRandomInformations
        var event: EKEvent!
        assertNotThrows(expr: event = try dictionaryParser.parse(eventDict), "Parser failed for \(eventDict).")
        assert(event, with: eventDict)
    }

    func testParseEventWithAllInfo() {
        let eventDict = EventFactory.eventWithAllInformations
        var event: EKEvent!
        assertNotThrows(expr: event = try dictionaryParser.parse(eventDict), "Parser failed for \(eventDict).")
        assert(event, with: eventDict)
    }

    func testParseEventsFromJSONFile() {
        var events = [EKEvent]()
        let resource = LaunchEnvironmentResource(bundle: "com.pgs-soft.AutoMateAppCompanionTests", name: "test_events")!
        assertNotThrows(expr: events = try dictionaryParser.parsed(resources: [resource]), "Data format corrupted.")

        XCTAssertEqual(events.count, 3, "Expected 3 events, got \(events.count)")
    }

    // MARK: Helpers
    func assertNotThrows(expr expression: (@autoclosure () throws -> Void), _ message: (@autoclosure () -> String)) {
        do {
            try expression()
        } catch let error {
            XCTFail("\(message()) Failed with unexpected error \(error).")
        }
    }

    func assertThrows<E: ErrorWithMessage>(expr expression: (@autoclosure () throws -> Void), errorType: E.Type, _ message: (@autoclosure () -> String)) {
        do {
            try expression()
        } catch let error {
            XCTAssertTrue(error is E, "\(message()) Failed with unexpected error \(error).")
        }
    }

    func assert(_ event: EKEvent, with dictionary: [String: Any]) {

        assertEqual(event.title, to: dictionary["title"])
        assertEqual(event.notes, to: dictionary["notes"])
        assertEqual(event.creationDate, to: date(from: dictionary["creationDate"]))
        assertEqual(event.startDate, to: date(from: dictionary["startDate"]))
        assertEqual(event.endDate, to: date(from: dictionary["endDate"]))
        assertCount(of: event.attendees, isEqual: dictionary["attendees"])
        // Location needs special handling because if set to .none it remains empty String.
        assertLocation(event.location, isEqual: dictionary["location"])
        XCTAssertEqual(event.calendar, calendar, "Event assigned to wrong calendar.")
    }

    func assertEqual<T: Equatable>(_ argument: T?, to expected: Any?) {
        switch expected {
        case .none:
            XCTAssertNil(argument, "Argument is \(argument) while expected is .none.")
        case let expectedT as T:
            XCTAssertEqual(expectedT, argument, "Value \(argument) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(argument) and \(expected) do not match.")
        }
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

    func date(from value: Any?) -> Date? {
        switch value {
        case .none:
            return nil
        case let dateString as String:
            return Date.from(representation: dateString)
        case .some:
            XCTFail("Wrong type of value \(value)")
            return nil
        }
    }

    func assertCount<C: Collection>(of argument: C?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertNil(argument, "Argument is \(argument) while expected is .none")
        case let aCollection as C:
            XCTAssertEqual(aCollection.count, argument?.count, "Value count \(argument?.count) is not equal to expected \(aCollection.count).")
        case .some:
            XCTFail("Types \(argument) and \(expected) do not match.")
        }
    }
}
