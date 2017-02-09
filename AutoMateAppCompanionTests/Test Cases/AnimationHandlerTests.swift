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
    func testAnimationHandler() {
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "false")
        XCTAssertFalse(UIView.areAnimationsEnabled)
    }

    func testDisableAnimation01() {
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "FALSE")
        XCTAssertFalse(UIView.areAnimationsEnabled)
    }

    func testDisableAnimation02() {
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "0")
        XCTAssertFalse(UIView.areAnimationsEnabled)
    }

    func testDisableAnimation03() {
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "No")
        XCTAssertFalse(UIView.areAnimationsEnabled)
    }

    func testEnableAnimation01() {
        UIView.setAnimationsEnabled(false)
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "true")
        XCTAssertTrue(UIView.areAnimationsEnabled)
    }

    func testEnableAnimation02() {
        UIView.setAnimationsEnabled(false)
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "TRUE")
        XCTAssertTrue(UIView.areAnimationsEnabled)
    }

    func testEnableAnimation03() {
        UIView.setAnimationsEnabled(false)
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "1")
        XCTAssertTrue(UIView.areAnimationsEnabled)
    }

    func testEnableAnimation04() {
        UIView.setAnimationsEnabled(false)
        animationHandler.handle(key: AutoMateLaunchOptionKey.animation.rawValue, value: "YES")
        XCTAssertTrue(UIView.areAnimationsEnabled)
    }
}
