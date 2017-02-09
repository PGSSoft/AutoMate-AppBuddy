//
//  LaunchEnviromentManager.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

// MARK: - Launch Enviroment Manager
public final class LaunchEnvironmentManager {

    // MARK: Properties
    private var handlers: [LaunchOptionKey: Handler] = [:]
    private let enviroment: [String: String]

    // MARK: Initialization
    public init(enviroment: [String: String] = ProcessInfo.processInfo.environment) {
        self.enviroment = enviroment
    }

    // MARK: Methods
    public func setup() {
        for (key, value) in enviroment {
            for (launchOptionKey, handler) in handlers where launchOptionKey == key {
                handler.handle(key: launchOptionKey, value: value)
            }
        }
    }

    public func add(handler: Handler, for key: LaunchOptionKey) {
        handlers[key] = handler
    }
}

// MARK: - Handler
public protocol Handler {

    // MARK: Methods
    func handle(key: String, value: String)
}

// MARK: - Launch Option Key
public typealias LaunchOptionKey = String
