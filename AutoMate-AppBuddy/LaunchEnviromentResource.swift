//
//  LaunchEnviromentResource.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 02/03/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

// MARK: - Launch Environment Resource
public struct LaunchEnvironmentResource {

    // MARK: Properties
    public static let CleanFlag = "AM_CLEAN_DATA_FLAG"
    public let bundle: Bundle
    public let name: String

    // MARK: Initialization
    public init?(bundle bundleName: String?, name: String) {
        guard let bundle = bundleName != nil ? Bundle(identifier: bundleName!) : Bundle.main else {
            return nil
        }
        self.bundle = bundle
        self.name = name
    }

    // MARK: Static methods
    public static func resource(from resourceString: String) -> LaunchEnvironmentResource? {
        let pair = resourceString.components(separatedBy: ":")
        let bundleName = pair.first != nil && pair.first != "nil" ? pair.first : nil

        guard let resourceName = pair.last,
            let resource = LaunchEnvironmentResource(bundle: bundleName, name: resourceName) else {
                return nil
        }
        return resource
    }

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
