//
//  FXCTestCase+AssertionHelpers.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 15/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
@testable import AutoMateAppCompanion

extension XCTestCase {

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

    func assertEqual<T: Equatable>(array: [T]?, to expected: Any?) {
        switch expected {
        case .none:
            XCTAssertNil(array, "Argument is \(array) while expected is empty.")
        case let expectedArr as [T]:
            XCTAssertTrue(array?.elementsEqual(expectedArr) ?? false, "Elements of \(array) are not equal to \(expectedArr)")
        default:
            XCTFail("Types \(array) and \(expected) do not match.")
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
