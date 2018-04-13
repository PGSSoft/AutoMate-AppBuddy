//
//  Dictionary+SafeAccess.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//
//  Strongly based on Soroush Khanlou Parser.swift (https://gist.github.com/khanlou)
//

import Foundation

// MARK: - Dictionary safe access helpers
public extension Dictionary {

    // MARK: Methods
    /// Get a value for a given `key` and return as an object `V`.
    /// If the value is not of the type `V` throws an error.
    ///
    /// - Parameter key: The key to find in the dictionary.
    /// - Returns: The value associated with `key`.
    /// - Throws: `ParserError` if `key` doesn't exists in the dictionary or it is not of the type `V`.
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

    /// Get a value for a given `key` and return as an optional object `V`.
    /// If the value is not of the type `V` throws an error.
    ///
    /// - Parameter key: The key to find in the dictionary.
    /// - Returns: The value associated with `key`, or `nil` if key doesn't exists in the dictionary.
    /// - Throws: `ParserError` if value is not of the type `V`.
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

    /// Get a value for a given `key` and return as an object `U` by transforming it from a type `V` to a type `U`.
    ///
    /// - Parameters:
    ///   - key: The key to find in the dictionary.
    ///   - transformation: Transformation closure. Transorms from type `V` to `U`.
    /// - Returns: The value associated with `key`.
    /// - Throws: `ParserError` if `key` doesn't exists in the dictionary or it is not of the type `V`, or it couldn't be transformed to type `U`.
    public func fetch<V, U>(_ key: Key, transformation: (V) throws -> U?) throws -> U {
        let fetched: V = try fetch(key)

        guard let transformed = try transformation(fetched) else {
            throw ParserError(message: "The value \"\(fetched)\" at key \"\(key)\" could not be transformed.")
        }

        return transformed
    }

    /// Get a value for a given `key` and return as an optional object `U` by transforming it from a type `V` to a type `U`.
    ///
    /// - Parameters:
    ///   - key: The key to find in the dictionary.
    ///   - transformation: Transformation closure. Transorms from type `V` to `U`.
    /// - Returns: The value associated with `key`.
    /// - Throws: `ParserError` if value is not of the type `V`, or it couldn't be transformed to type `U`.
    public func fetchOptional<V, U>(_ key: Key, transformation: (V) throws -> U?) throws -> U? {

        return try fetchOptional(key).flatMap(transformation)
    }

    /// Get a value for a given `key` and return as an optional array of object `U` by transforming each object of a type `V` to a type `U`.
    ///
    /// - Parameters:
    ///   - key: The key to find in the dictionary.
    ///   - transformation: Transformation closure. Transorms from type `V` to `U`.
    /// - Returns: An optional array of values associated with `key`.
    /// - Throws: `ParserError` if objects cannot be transformed to type `U`.
    public func fetchOptionalArray<V, U>(_ key: Key, transformation: (V) throws -> U?) throws -> [U]? {

        guard let fetched: [V] = try fetchOptional(key) else {
            return nil
        }
        return try fetched.compactMap(transformation)
    }

    /// Return first pair (key and value) from dictionary.
    ///
    /// - Returns: First pair (key and value) from dictionary.
    /// - Throws: `ParserError` if dictionary is empty.
    public func fetchFirst() throws -> (key: Key, value: Value) {
        guard let fetched = first else {
            throw ParserError(message: "Missing key or value")
        }
        return fetched
    }

    /// Return first pair (key and value) from dictionary and transform it to type `T`.
    ///
    /// - Parameter transformation: Transformation closure. Transorms key and value to the type `T`.
    /// - Returns: First pair (key and value) transformed to type `T`.
    /// - Throws: `ParserError` if dictionary is empty.
    public func fetchFirst<T>(transformation: (Key, Value) throws -> T) throws -> T {
        let fetched = try fetchFirst()
        return try transformation(fetched.key, fetched.value)
    }
}
