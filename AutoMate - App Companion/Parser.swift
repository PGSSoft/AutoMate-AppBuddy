//
//  Parser.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
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

    // MARK: Methods
    func parse(_ data: Any) throws -> T
}

// MARK: Default implementations
public extension Parser {

    // MARK: Methods
    public func parsed(resources: [LaunchEnviromentResource]) throws -> [Self.T] {
        let jsonsData = resources.flatMap { $0.bundle.jsonArray(with: $0.name) }
        let flattenData = jsonsData.reduce([], +)
        return try flattenData.flatMap { return try parse($0) }
    }
}

// MARK: - Launch Enviroment Resource
public struct LaunchEnviromentResource {

    // MARK: Properties
    public let bundle: Bundle
    public let name: String

    // MARK: Initialization
    public init?(bundle bundleName: String?, name: String) {
        guard let bundle = bundleName != nil ? Bundle(identifier: bundleName!) : Bundle.main else {
            return nil
        }
        self.bundle = bundle
        self.name = name
    }

    // MARK: Static methods
    public static func resources(from resourcesString: String) -> [LaunchEnviromentResource] {
        let pairs = resourcesString.components(separatedBy: ",")

        return pairs.flatMap {
            let pair = $0.components(separatedBy: ":")
            let bundleName = pair.first != nil && pair.first != "nil" ? pair.first : nil

            guard let resourceName = pair.last,
                let resource = LaunchEnviromentResource(bundle: bundleName, name: resourceName) else {
                    return nil
            }
            return resource
        }
    }
}
