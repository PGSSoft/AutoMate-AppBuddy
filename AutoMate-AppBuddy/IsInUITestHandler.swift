//
//  IsInUITestHandler.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda (PGS Software) on 29.06.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

// MARK: - IsInUITestHandler
/// Provides information whether the application is running under UI test environment.
///
/// Handler should be added to `LaunchEnvironmentManager`.
///
/// Used key: `AM_IS_IN_UI_TEST` / `AutoMateLaunchOptionKey.isInUITest`.
///
/// Supported values (case insensitive):
///
/// - `true`
/// - `yes`
/// - `1`
/// - `false`
/// - `no`
/// - `0`
///
/// **Example:**
///
/// ```swift
/// let launchManager = LaunchEnvironmentManager()
/// let isInUITest = IsInUITestHandler()
/// launchManager.add(handler: isInUITest, for: .isInUITest)
/// launchManager.setup()
/// ```
///
/// Later in the code, you can check whether the application is running in UI test environment, by using below example:
///
/// **Example:**
///
/// ```swift
/// if isInUITest.inUITest {
///     ...
/// }
/// ```
///
/// - note:
///   `defaultIsInUITestHandler` singleton could be used intead of creating new instance of the `IsInUITestHandler`.
///
/// - note:
///   Launch environment for the handler can be set by the `IsInUITestLaunchEnvironment`
///   from the [AutoMate](https://github.com/PGSSoft/AutoMate) project.
///
/// - note:
///   `IsInUITestHandler` should be used with the `AM_IS_IN_UI_TEST` key, but its implementation doesn't require to use it.
///   Any key provided to the `LaunchEnvironmentManager.add(handler:for:)` method will be handled correctly.
///
/// - seealso: `LaunchEnvironmentManager`
/// - seealso: `defaultIsInUITestHandler`
public class IsInUITestHandler: Handler {

    // MARK: Properties
    /// Indicates whether the application is running in UI test environment.
    private(set) public var inUITest: Bool = false

    // MARK: Initialization
    /// Initialize `IsInUITestHandler`.
    public init() { }

    // MARK: Handler
    /// Handles value for the `AM_IS_IN_UI_TEST` key and provides information whether the application was run in the UI test environment.
    ///
    /// - note:
    ///   `IsInUITestHandler` should be used with the `AM_IS_IN_UI_TEST` key, but its implementation doesn't require to use it.
    ///   Any key provided to the `LaunchEnvironmentManager.add(handler:for:)` method will be handled correctly.
    ///
    /// - requires:
    ///   Method support only given set of values (case insensitive):
    ///
    ///   - `true`
    ///   - `yes`
    ///   - `1`
    ///   - `false`
    ///   - `no`
    ///   - `0`
    ///
    /// - Parameters:
    ///   - key: `AM_IS_IN_UI_TEST` / `AutoMateLaunchOptionKey.isInUITest`
    ///   - value: Value for the `key`.
    public func handle(key: String, value: String) {
        guard let inUITest = value.boolValue else {
            assertionFailure("Cannot convert value for key \"\(key)\" to Bool")
            return
        }

        self.inUITest = inUITest
    }
}

// MARK: - Default IsInUITestHandler
/// Default `IsInUITestHandler` instance. Singleton which will store information whether the application is running in UI test environment.
///
/// **Example:**
/// ```swift
/// let launchManager = LaunchEnvironmentManager()
/// launchManager.add(handler: defaultIsInUITestHandler, for: .isInUITest)
/// launchManager.setup()
/// ```
///
/// - seealso: `IsInUITestHandler`
public let defaultIsInUITestHandler = IsInUITestHandler()
