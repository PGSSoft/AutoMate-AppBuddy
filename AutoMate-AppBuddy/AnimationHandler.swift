//
//  AnimationHandler.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 03.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import UIKit

public struct AnimationHandler: Handler {

    // MARK: Properties
    public static let key = AutoMateLaunchOptionKey.animation

    // MARK: Initialization
    public init() { }

    // MARK: Handler
    public func handle(key: String, value: String) {
        guard let animation = value.boolValue else {
            assertionFailure("Cannot convert \(AnimationHandler.key) to Bool")
            return
        }

        UIView.setAnimationsEnabled(animation)
    }
}
