//
//  LaunchEnviromentResource.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 02/03/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

// MARK: - Launch Environment Resource

/// Stores "resource" as a name of the resource and `Bundle` in which the resource is available.
///
/// Resource is initialized with a bundle description (a bundle name or a bundle identifier) and a name of the resource.
/// If bundle name is `nil` then `Bundle.main` is used.
///
/// Resource can be parsed from string.
///
/// Resources representation: is made of "resource representation" separated by comma.
/// In addition, the `CleanFlag` can be used as first element.
///
/// Resource representation: is made of a bundle name (or a bundle identifier) and a resource name
/// separated with colon. Bundle name can be a `nil` string then the `Bundle.main` will be used.
///
/// **Example:**
///
/// ```
/// Test data:events,nil:contacts
/// AM_CLEAN_DATA_FLAG,Test data:events,nil:contacts
/// ```
public struct LaunchEnvironmentResource {

    // MARK: Properties
    /// Clean flag indicating that existing data should be removed (eg. contacts) before adding new one.
    public static let CleanFlag = "AM_CLEAN_DATA_FLAG"

    /// `Bundle` object where resource is available.
    public let bundle: Bundle

    /// Resource name.
    public let name: String

    // MARK: Initialization
    /// Initialize the resource with a bundle description (a bundle name or a bundle identifier) and a name of the resource.
    ///
    /// - Parameters:
    ///   - bundleDescription: Bundle name or bundle identifier. If `nil` `Bundle.main` will be used.
    ///   - name: Name of the resource.
    /// - Returns: `nil` if cannot find a bundle with given name or identifier.
    public init?(bundle bundleDescription: String?, name: String) {
        guard let bundle = Bundle.with(stringDescription: bundleDescription) else { return nil }
        self.bundle = bundle
        self.name = name
    }

    // MARK: Static methods
    /// Parse resource from string.
    ///
    /// String representation is made of a bundle name (or a bundle identifier) and a resource name
    /// separated with colon. Bundle name can be a `nil` string then the `Bundle.main` will be used.
    ///
    /// **Example:**
    ///
    /// ```
    /// Test data:events
    /// nil:contacts
    /// ```
    ///
    /// - Parameter resourceString: String representation of the resource.
    /// - Returns: `nil` if cannot find a bundle with given name or identifier.
    public static func resource(from resourceString: String) -> LaunchEnvironmentResource? {
        let pair = resourceString.components(separatedBy: ":")
        let bundleName = pair.first != nil && pair.first != "nil" ? pair.first : nil

        guard let resourceName = pair.last,
            let resource = LaunchEnvironmentResource(bundle: bundleName, name: resourceName) else {
                return nil
        }
        return resource
    }

    /// Parse resources from string.
    ///
    /// String representation is made of "resource representation" separated by comma.
    /// In addition, the `CleanFlag` can be used as first element.
    ///
    /// Resource representation: is made of a bundle name (or a bundle identifier) and a resource name
    /// separated with colon. Bundle name can be a `nil` string then the `Bundle.main` will be used.
    ///
    /// **Example:**
    ///
    /// ```
    /// Test data:events,nil:contacts
    /// AM_CLEAN_DATA_FLAG,Test data:events,nil:contacts
    /// ```
    ///
    /// - Parameter resourcesString: String representation of the resources.
    /// - Returns: List of resources and `clean` flag.
    public static func resources(from resourcesString: String) -> ([LaunchEnvironmentResource], Bool) {
        var pairs = resourcesString.components(separatedBy: ",")
        var isCleanFlag = false

        if let first = pairs.first, first.isCleanFlag {
            pairs.removeFirst()
            isCleanFlag = true
        }

        return (pairs.flatMap { LaunchEnvironmentResource.resource(from: $0) }, isCleanFlag)
    }
}
