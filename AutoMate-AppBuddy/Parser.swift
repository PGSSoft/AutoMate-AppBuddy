//
//  Parser.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

protocol ErrorWithMessage: Error {
    var message: String { get }
}

// MARK: Parser Error
public struct ParserError: ErrorWithMessage {

    // MARK: Properties
    let message: String
}

// MARK: Parser
public protocol Parser {

    // MARK: Associatedtypes
    associatedtype T
    associatedtype U

    // MARK: Methods
    func parse(_ data: T) throws -> U
}

// MARK: Default implementations
public extension Parser where T == Any {

    // MARK: Methods
    public func parsed(resources: [LaunchEnvironmentResource]) throws -> [Self.U] {
        let jsonsData = resources.flatMap { $0.bundle.jsonArray(with: $0.name) }
        let flattenData = jsonsData.reduce([], +)
        return try flattenData.flatMap { try parse($0) }
    }
}
