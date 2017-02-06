//
//  AnimationHandler.swift
//  AutoMate App Companion
//
//  Created by Bartosz Janda on 03.02.2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import UIKit

public struct AnimationHandler: Handler {

    // MARK: Properties
    public static let key = AutoMateLaunchOptionKey.animation

    //MARK: Handler
    public func handle(key: String, value: String) {
        guard let animation = value.toBool() else {
            assertionFailure("Cannot convert \(AnimationHandler.key) to Bool")
            return
        }

        UIView.setAnimationsEnabled(animation)
    }
}
