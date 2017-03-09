//
//  AnimationHandler.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 03.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import UIKit

/// Handle enabling and disabling UIKit animations.
///
/// Handler should be added to `LaunchEnvironmentManager`.
///
/// Used key: `AM_ANIMATION_KEY` / `AutoMateLaunchOptionKey.animation`
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
/// launchManager.add(handler: AnimationHandler(), for: .animation)
/// launchManager.setup()
/// ```
///
/// - note:
///   Launch environment for the handler can be set by the `AnimationLaunchEnvironment`
///   from the [AutoMate](https://github.com/PGSSoft/AutoMate) project.
///
/// - note:
///   `AnimationHandler` should be used with the `AM_ANIMATION_KEY` key, but its implementation doesn't require to use it.
///   Any key provided to the `LaunchEnvironmentManager.add(handler:for:)` method will be handled correctly.
public struct AnimationHandler: Handler {

    // MARK: Initialization
    /// Initialize `AnimationHandler`.
    public init() { }

    // MARK: Handler
    /// Handle value for `AM_ANIMATION_KEY` key and enable or disable UIKit animation.
    ///
    /// - note:
    ///   `AnimationHandler` should be used with the `AM_ANIMATION_KEY` key, but its implementation doesn't require to use it.
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
    ///   - key: `AM_ANIMATION_KEY` / `AutoMateLaunchOptionKey.animation`
    ///   - value: Value for the `key`.
    public func handle(key: String, value: String) {
        guard let animation = value.boolValue else {
            assertionFailure("Cannot convert value for key \"\(key)\" to Bool")
            return
        }

        UIView.setAnimationsEnabled(animation)
    }
}
