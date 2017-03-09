//
//  LaunchOptionsKeys.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

// MARK: - Auto Mate Launch Option Key

/// Represents key used in the launch environments handled by AppBudy.
///
/// - `animation`: Used to enable / disable animation, used by the `AnimationHandler`.
/// - `contacts`: Used to manage contacs by the `ContactsHandler`.
/// - `events`: Used to manage events by the `EventKitHandler`.
/// - `reminders`: Used to manage reminders by the `EventKitHandler`.
public enum AutoMateLaunchOptionKey: LaunchOptionKey {

    /// Used to enable / disable animation, used by the `AnimationHandler`.
    case animation = "AM_ANIMATION_KEY"

    /// Used to manage contacs by the `ContactsHandler`.
    case contacts = "AM_CONTACTS_KEY"

    /// Used to manage events by the `EventKitHandler`.
    case events = "AM_EVENTS_KEY"

    /// Used to manage reminders by the `EventKitHandler`.
    case reminders = "AM_REMINDERS_KEY"
}
