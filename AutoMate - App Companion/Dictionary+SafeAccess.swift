//
//  Dictionary+SafeAccess.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//
//  Strongly based on Soroush Khanlou Parser.swift (https://gist.github.com/khanlou)
//

import Foundation

// MARK: - Dictionary safe access helpers
public extension Dictionary {

    // MARK: Methods
    public func fetch<V>(_ key: Key) throws -> V {
        let fetchedOptional = self[key]

        guard let fetched = fetchedOptional else {
            throw ParserError(message: "The key \"\(key)\" was not found.")
        }

        guard let typed = fetched as? V else {
            throw ParserError(message: "The key \"\(key)\" was not the right type. It had value \"\(fetched).\"")
        }

        return typed
    }

    public func fetchOptional<V>(_ key: Key) throws -> V? {
        let fetchedOptional = self[key]

        guard let fetched = fetchedOptional else {
            return nil
        }

        guard let typed = fetched as? V else {
            throw ParserError(message: "The key \"\(key)\" was not the right type. It had value \"\(fetched).\"")
        }

        return typed
    }

    public func fetch<V, U>(_ key: Key, transformation: (V) -> U?) throws -> U {
        let fetched: V = try fetch(key)

        guard let transformed = transformation(fetched) else {
            throw ParserError(message: "The value \"\(fetched)\" at key \"\(key)\" could not be transformed.")
        }

        return transformed
    }

    public func fetchOptional<V, U>(_ key: Key, transformation: (V) -> U?) throws -> U? {

        return try fetchOptional(key).flatMap(transformation)
    }

    public func fetchOptionalArray<V, U>(_ key: Key, transformation: (V) throws -> U?) throws -> [U]? {

        guard let fetched: [V] = try fetchOptional(key) else {
            return nil
        }
        return try fetched.flatMap(transformation)
    }
}
