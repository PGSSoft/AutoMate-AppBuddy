//
//  Parser.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

// MARK: - ErrorWithMessage
/// Error used by the `AutoMate-AppBuddy`.
protocol ErrorWithMessage: Error {
    var message: String { get }
}

// MARK: - Parser Error
/// Error used by the `AutoMate-AppBuddy`.
public struct ParserError: ErrorWithMessage {

    // MARK: Properties
    let message: String
}

// MARK: - Parser
/// Defines types and method required to parse and convert any type `T` to a type `U`.
public protocol Parser {

    // MARK: Associatedtypes
    associatedtype T
    associatedtype U

    // MARK: Methods
    /// Methods which converts a type `T` to a type `U`.
    ///
    /// - Parameter data: Object to convert, eg. `Dictionary`.
    /// - Returns: Converted object, eg. `CNMutableContact`.
    /// - Throws: Throws an error if object cannot be converted.
    func parse(_ data: T) throws -> U
}

// MARK: - Default implementations
public extension Parser {

    // MARK: Methods
    /// Extension of the `parse(_:)` method, which reads JSON arrays from `LaunchEnvironmentResource`
    /// and returns a list of objects converted by `parse(_:)` method.
    ///
    /// - Parameter resources: A list of resources to parse.
    /// - Returns: A list of converted objects.
    /// - Throws: Rethrow an error throwed by `parse(_:)` method.
    public func parsed(resources: [LaunchEnvironmentResource]) throws -> [Self.U] {
        let jsonsData: [[T]] = resources.compactMap { $0.bundle.jsonArray(with: $0.name) }
        let flattenData = jsonsData.reduce([], +)
        return try flattenData.compactMap { try parse($0) }
    }
}
