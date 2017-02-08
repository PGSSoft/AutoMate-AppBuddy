//
//  LaunchEnviromentResourceTests.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 08/02/2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import XCTest
@testable import AutoMateAppCompanion

class LaunchEnviromentResourceTests: XCTestCase {

    // MARK: Properties
    let mainBundleResource = "nil:resource_from_main_bundle"
    let testBundleResource = "com.pgs-soft.AutoMateAppCompanionTests:resource_from_test_bundle"
    let fakeBundleResource = "fakeBundleIdentifier:resource_from_test_bundle"

    // MARK: Tests
    func testParsingLaunchEnviromentValueToResourceInMainBundle() {
        let resources = LaunchEnviromentResource.resources(from: mainBundleResource)
        XCTAssertEqual(resources.count, 1, "Resource \(mainBundleResource) is missing.")

        let resource = resources.first!
        XCTAssertEqual(resource.name, "resource_from_main_bundle", "Resource \(mainBundleResource) has unexpected name \(resource.name)")
        XCTAssertEqual(resource.bundle, Bundle.main, "Expected main bundle, found \(resource.bundle.bundleIdentifier)")
    }

    func testParsingLaunchEnviromentValueToResourceInExternalBundle() {
        let resources = LaunchEnviromentResource.resources(from: testBundleResource)
        XCTAssertEqual(resources.count, 1, "Resource \(testBundleResource) is missing.")

        let resource = resources.first!
        XCTAssertEqual(resource.name, "resource_from_test_bundle", "Resource \(testBundleResource) has unexpected name \(resource.name)")
        XCTAssertEqual(resource.bundle, Bundle(identifier: "com.pgs-soft.AutoMateAppCompanionTests"), "Bundle has unexpected identifier, \(resource.bundle.bundleIdentifier) instead of com.pgs-soft.AutoMateAppCompanionTests")
    }

    func testParsingLaunchEnviromentValueToResourceInNotExistingBundle() {
        let resources = LaunchEnviromentResource.resources(from: fakeBundleResource)
        XCTAssertEqual(resources.count, 0, "Resource \(fakeBundleResource) with not existing bundle found.")
    }

    func testParsingMultipleLaunchEnviromentValueToResources() {
        let resources = LaunchEnviromentResource.resources(from: "\(testBundleResource),\(fakeBundleResource),\(mainBundleResource)")
        XCTAssertEqual(resources.count, 2, "Expected 2 resources, got \(resources.count).")

        var resource = resources.first!
        XCTAssertEqual(resource.name, "resource_from_test_bundle", "Resource \(testBundleResource) has unexpected name \(resource.name)")
        XCTAssertEqual(resource.bundle, Bundle(identifier: "com.pgs-soft.AutoMateAppCompanionTests"), "Bundle has unexpected identifier, \(resource.bundle.bundleIdentifier) instead of com.pgs-soft.AutoMateAppCompanionTests")

        resource = resources.last!
        XCTAssertEqual(resource.name, "resource_from_main_bundle", "Resource \(mainBundleResource) has unexpected name \(resource.name)")
        XCTAssertEqual(resource.bundle, Bundle.main, "Expected main bundle, found \(resource.bundle.bundleIdentifier)")
    }
}
