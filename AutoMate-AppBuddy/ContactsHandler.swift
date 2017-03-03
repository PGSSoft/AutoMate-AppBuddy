//
//  ContactsHandler.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 22.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation
import Contacts

// MARK: - Contacts Handler
public struct ContactsHandler<C: ContactParser, I: ContactsInterface>: Handler {

    // MARK: Properties
    public let contactParser: C
    public let contactsInterface: I

    // MARK: Initialization
    public init(withParser contactParser: C, contactsInterface: I) {
        self.contactParser = contactParser
        self.contactsInterface = contactsInterface
    }

    // MARK: Methods
    public func handle(key: String, value: String) {
        let (resources, cleanFlag) = LaunchEnvironmentResource.resources(from: value)
        let contacts = (try? self.contactParser.parsed(resources: resources)) ?? []
        contactsInterface.requestAccess { (authenticated, error) in
            guard error == nil, authenticated else { return }
            self.removeAll(ifNeeded: cleanFlag) { (_, _) in
                self.contactsInterface.addAll(contacts, completion: { _, _ in })
            }
        }
    }

    private func removeAll(ifNeeded cleanNeeded: Bool, completion: @escaping (Bool, Error?) -> Void) {
        guard cleanNeeded else {
            completion(false, nil)
            return
        }

        contactsInterface.removeAll(completion: completion)
    }
}

// MARK: - Default Contacts Handler
public let defaultContactsHander = ContactsHandler(withParser: ContactDictionaryParser(with: CNContactStore()), contactsInterface: ContactsInterface())
