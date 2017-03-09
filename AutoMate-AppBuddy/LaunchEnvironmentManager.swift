//
//  LaunchEnvironmentManager.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

// MARK: - Launch Environment Manager
/// Handles launch environments passed by the UI test runner.
/// Launch environments passed by the [AutoMate](https://github.com/PGSSoft/AutoMate) are working.
///
/// `LaunchEnvironmentManager` should be initialized in the application delegate
/// in method `application(_:didFinishLaunchingWithOptions:)`.
///
/// **Example:**
///
/// ```swift
/// let launchManager = aunchEnvironmentManager()
/// launchManager.add(handler: defaultContactsHander, .contacts)
/// launchManager.setup()
/// ```
public final class LaunchEnvironmentManager {

    // MARK: Properties
    private var handlers: [LaunchOptionKey: Handler] = [:]
    private let environment: [String: String]

    // MARK: Initialization

    /// Initialize object with launch environments.
    /// By default `ProcessInfo.processInfo.environment` is used.
    ///
    /// - Parameter environment: launch environment passed to the application.
    public init(environment: [String: String] = ProcessInfo.processInfo.environment) {
        self.environment = environment
    }

    // MARK: Methods
    /// Process launch environemtns and pass them to correct handlers.
    public func setup() {
        for (key, value) in environment {
            for (launchOptionKey, handler) in handlers where launchOptionKey == key {
                handler.handle(key: launchOptionKey, value: value)
            }
        }
    }

    /// Add new `Handler` object which process data from launch environments with given `key`.
    ///
    /// - Parameters:
    ///   - handler: Object implementing `Handler` protocol.
    ///   - key: Key for which `handler` will be executed.
    public func add(handler: Handler, for key: LaunchOptionKey) {
        handlers[key] = handler
    }

    /// Add new `Handler` object which process data from launch environments with given `key`.
    ///
    /// - Parameters:
    ///   - handler: Object implementing `Handler` protocol.
    ///   - key: Key for which `handler` will be executed.
    public func add(handler: Handler, for key: AutoMateLaunchOptionKey) {
        handlers[key.rawValue] = handler
    }
}

// MARK: - Handler
/// Protocol defining necessary methods required by the `LaunchEnvironmentManager` to handle launch environments.
///
/// - seealso: `LaunchEnvironmentManager`
public protocol Handler {

    // MARK: Methods
    /// Handles launch environment with given `key` and `value`.
    ///
    /// - Parameters:
    ///   - key: Key of the launch environment.
    ///   - value: Value of the launch environment.
    func handle(key: String, value: String)
}

// MARK: - Launch Option Key
public typealias LaunchOptionKey = String
