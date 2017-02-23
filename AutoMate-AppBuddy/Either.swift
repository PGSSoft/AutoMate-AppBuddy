//
//  Either.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 22.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

// MARK: - Either
enum Either<T> {
    case left(T)
    case right(String)

    init(_ left: T?, or right: String) {
        self = left != nil ? .left(left!) : .right(right)
    }
}

extension Either where T: RawRepresentable, T.RawValue == String {

    var stringValue: String {
        switch self {
        case .left(let value):
            return value.rawValue
        case .right(let value):
            return value
        }
    }

    init(string: String) {
        self.init(T(rawValue: string), or: string)
    }
}

extension Either: Equatable {
    static func == (lhs: Either, rhs: Either) -> Bool {
        switch (lhs, rhs) {
        case (.left, .left):
            return true
        case let (.right(lhsv), .right(rhsv)):
            return lhsv == rhsv
        default:
            return false
        }
    }
}

extension Either where T: Equatable {

    static func == (lhs: Either, rhs: Either) -> Bool {
        switch (lhs, rhs) {
        case let (.left(lhsv), .left(rhsv)):
            return lhsv == rhsv
        case let (.right(lhsv), .right(rhsv)):
            return lhsv == rhsv
        default:
            return false
        }
    }
}
