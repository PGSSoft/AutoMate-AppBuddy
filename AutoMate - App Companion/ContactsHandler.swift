//
//  ContactsHandler.swift
//  AutoMate App Companion
//
//  Created by Bartosz Janda on 22.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation
import Contacts

// MARK: - Contacts Handler
public struct ContactsHandler<C: ContactParser>: Handler {

    // MARK: Properties
    public let contactParser: C

    // MARK: Initialization
    public init(withParser contactParser: C) {
        self.contactParser = contactParser
    }

    // MARK: Methods
    public func handle(key: String, value: String) {
        let resources = LaunchEnvironmentResource.resources(from: value)
        try? contactParser.parseAndSave(resources: resources)
    }
}

// MARK: - Default Contacts Handler
public let defaultContactsHander = ContactsHandler(withParser: ContactDictionaryParser(with: CNContactStore()))
