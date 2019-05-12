//
//  FXCTestCase+AssertionHelpers.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 15/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
@testable import AutoMate_AppBuddy

extension XCTestCase {

    // MARK: Assertions
    func assertNotThrows(expr expression: @autoclosure () throws -> Void, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
        do {
            try expression()
        } catch let error {
            XCTFail("\(message()) Failed with unexpected error \(error).", file: file, line: line)
        }
    }

    func assertThrows<E: ErrorWithMessage>(expr expression: @autoclosure () throws -> Void, errorType: E.Type, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
        do {
            try expression()
            XCTFail("\(message()) Expressions didn't throw.", file: file, line: line)
        } catch let error {
            XCTAssertTrue(error is E, "\(message()) Failed with unexpected error \(error).", file: file, line: line)
        }
    }

    func assert<T: Equatable>(_ argument: T?, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTAssertNil(argument, "Argument is \(argument.debugDescription) while expected is .none.", file: file, line: line)
        case let expectedT as T:
            XCTAssertEqual(expectedT, argument, "Value \(argument.debugDescription) is not equal to \(expectedT)", file: file, line: line)
        default:
            XCTFail("Types \(argument.debugDescription) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    func assert<T: Equatable>(array: [T]?, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTAssertNil(array, "Argument is \(array.debugDescription) while expected is empty.", file: file, line: line)
        case let expectedArr as [T]:
            XCTAssertTrue(array?.elementsEqual(expectedArr) ?? false, "Elements of \(array.debugDescription) are not equal to \(expectedArr)", file: file, line: line)
        default:
            XCTFail("Types \(array.debugDescription) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    func assert<C: Collection>(countOf argument: C?, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTAssertNil(argument, "Argument is \(argument.debugDescription) while expected is .none", file: file, line: line)
        case let aCollection as C:
            XCTAssertEqual(aCollection.count, argument?.count, "Value count \(argument?.count ?? 0) is not equal to expected \(aCollection.count).", file: file, line: line)
        case .some:
            XCTFail("Types \(argument.debugDescription) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    @nonobjc func assert(dateComponents: DateComponents?, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTAssertNil(dateComponents, "Argument is \(dateComponents.debugDescription) while expected is .none", file: file, line: line)
        case let expectedT as [String: Any]:
            do {
                let expectedDateComponents = try DateComponents.parse(from: expectedT)
                XCTAssertEqual(dateComponents, expectedDateComponents, file: file, line: line)
            } catch let error {
                XCTFail("Failed with unexpected error \(error).", file: file, line: line)
            }
        case .some:
            XCTFail("Types \(dateComponents.debugDescription) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    @nonobjc func assert(dateComponents: NSDateComponents?, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        assert(dateComponents: dateComponents as DateComponents?, isEqual: expected, file: file, line: line)
    }

    // MARK: Helpers
    func date(from value: Any?, file: StaticString = #file, line: UInt = #line) -> Date? {
        switch value {
        case .none:
            return nil
        case let dateString as String:
            return Date.from(representation: dateString)
        case .some:
            XCTFail("Wrong type of value \(value.debugDescription)", file: file, line: line)
            return nil
        }
    }
}
