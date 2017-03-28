//
//  LaunchEnvironmentResourceTests.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 08/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
@testable import AutoMate_AppBuddy

class LaunchEnvironmentResourceTests: XCTestCase {

    // MARK: Properties
    let mainBundleResource = "nil:resource_from_main_bundle"
    let testBundleResource = "com.pgs-soft.AutoMate-AppBuddyTests:resource_from_test_bundle"
    let testBundleResourceWithClean = "AM_CLEAN_DATA_FLAG,com.pgs-soft.AutoMate-AppBuddyTests:resource_from_test_bundle"
    let fakeBundleResource = "fakeBundleIdentifier:resource_from_test_bundle"

    // MARK: Tests
    func testParsingLaunchEnvironmentValueToResourceInMainBundle() {
        let (resources, cleanFlag) = LaunchEnvironmentResource.resources(from: mainBundleResource)
        XCTAssertEqual(resources.count, 1, "Resource \(mainBundleResource) is missing.")
        XCTAssertFalse(cleanFlag, "Unexpected to find flag to clean data in resource \(mainBundleResource)")

        let resource = resources.first!
        XCTAssertEqual(resource.name, "resource_from_main_bundle", "Resource \(mainBundleResource) has unexpected name \(resource.name)")
        XCTAssertEqual(resource.bundle, Bundle.main, "Expected main bundle, found \(String(describing: resource.bundle.bundleIdentifier))")
    }

    func testParsingLaunchEnvironmentValueToResourceInExternalBundle() {
        let (resources, cleanFlag) = LaunchEnvironmentResource.resources(from: testBundleResource)
        XCTAssertEqual(resources.count, 1, "Resource \(testBundleResource) is missing.")
        XCTAssertFalse(cleanFlag, "Unexpected to find flag to clean data in resource \(testBundleResource)")

        let resource = resources.first!
        XCTAssertEqual(resource.name, "resource_from_test_bundle", "Resource \(testBundleResource) has unexpected name \(resource.name)")
        XCTAssertEqual(resource.bundle, Bundle(identifier: "com.pgs-soft.AutoMate-AppBuddyTests"), "Bundle has unexpected identifier, \(String(describing: resource.bundle.bundleIdentifier)) instead of com.pgs-soft.AutoMate-AppBuddyTests")
    }

    func testParsingLaunchEnvironmentValueToResourceInExternalBundleWithCleanFlag() {
        let (resources, cleanFlag) = LaunchEnvironmentResource.resources(from: testBundleResourceWithClean)
        XCTAssertEqual(resources.count, 1, "Resource \(testBundleResourceWithClean) is missing.")
        XCTAssertTrue(cleanFlag, "Expected to find flag to clean data in resource \(testBundleResourceWithClean)")

        let resource = resources.first!
        XCTAssertEqual(resource.name, "resource_from_test_bundle", "Resource \(testBundleResourceWithClean) has unexpected name \(resource.name)")
        XCTAssertEqual(resource.bundle, Bundle(identifier: "com.pgs-soft.AutoMate-AppBuddyTests"), "Bundle has unexpected identifier, \(String(describing: resource.bundle.bundleIdentifier)) instead of com.pgs-soft.AutoMate-AppBuddyTests")
    }

    func testParsingLaunchEnvironmentValueToResourceInNotExistingBundle() {
        let (resources, cleanFlag) = LaunchEnvironmentResource.resources(from: fakeBundleResource)
        XCTAssertEqual(resources.count, 0, "Resource \(fakeBundleResource) with not existing bundle found.")
        XCTAssertFalse(cleanFlag, "Unexpected to find flag to clean data in resource \(fakeBundleResource)")
    }

    func testParsingMultipleLaunchEnvironmentValueToResources() {
        let (resources, cleanFlag) = LaunchEnvironmentResource.resources(from: "\(testBundleResource),\(fakeBundleResource),\(mainBundleResource)")
        XCTAssertEqual(resources.count, 2, "Expected 2 resources, got \(resources.count).")
        XCTAssertFalse(cleanFlag, "Unexpected to find flag to clean data in resource \(testBundleResource),\(fakeBundleResource),\(mainBundleResource)")

        var resource = resources.first!
        XCTAssertEqual(resource.name, "resource_from_test_bundle", "Resource \(testBundleResource) has unexpected name \(resource.name)")
        XCTAssertEqual(resource.bundle, Bundle(identifier: "com.pgs-soft.AutoMate-AppBuddyTests"), "Bundle has unexpected identifier, \(String(describing: resource.bundle.bundleIdentifier)) instead of com.pgs-soft.AutoMate-AppBuddyTests")

        resource = resources.last!
        XCTAssertEqual(resource.name, "resource_from_main_bundle", "Resource \(mainBundleResource) has unexpected name \(resource.name)")
        XCTAssertEqual(resource.bundle, Bundle.main, "Expected main bundle, found \(String(describing: resource.bundle.bundleIdentifier))")
    }
}
