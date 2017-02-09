//
//  AnimationHandlerTests.swift
//  AutoMate App Companion
//
//  Created by Bartosz Janda on 09.02.2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import XCTest
import AutoMateAppCompanion

class AnimationHandlerTests: XCTestCase {

    // MARK: Properties
    var animationHandler: AnimationHandler!

    // MARK: Setup
    override func setUp() {
        super.setUp()
        animationHandler = AnimationHandler()
        UIView.setAnimationsEnabled(true)
    }

    override func tearDown() {
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    // MARK: Tests
    func testDisableAnimation() {
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "false")
        XCTAssertFalse(UIView.areAnimationsEnabled)
    }

    func testEnableAnimation() {
        UIView.setAnimationsEnabled(false)
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "true")
        XCTAssertTrue(UIView.areAnimationsEnabled)
    }
}
