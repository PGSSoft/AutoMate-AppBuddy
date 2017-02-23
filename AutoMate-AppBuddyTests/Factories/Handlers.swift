//
//  Handlers.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 02/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation
import AutoMate_AppBuddy

class MockHandler: Handler {
    // MARK: Static properties
    static private var instancesCount = 0

    // MARK: Properties
    var key: String {
        return "RESOURCE_KEY_\(instanceNumber)"
    }
    private(set) var received: (key: String, value: String)?
    private let instanceNumber: Int

    // MARK: Initialization
    init() {
        instanceNumber = MockHandler.instancesCount
        MockHandler.instancesCount += 1
    }

    // MARK: Methods
    func handle(key: String, value: String) {
        self.received = (key, value)
    }
}
