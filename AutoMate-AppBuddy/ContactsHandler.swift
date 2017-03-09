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
/// Handles contacts by using `Contacts` framework.
///
/// Handler should be added to `LaunchEnvironmentManager`.
///
/// Used key: `AM_CONTACTS_KEY` / `AutoMateLaunchOptionKey.contacts`.
///
/// Supported values: `LaunchEnvironmentResource` resources representation as a string.
///
/// **Example:**
///
/// ```swift
/// let launchManager = LaunchEnvironmentManager()
/// let contactsHander = ContactsHandler(withParser: ContactDictionaryParser(with: CNContactStore()), contactsInterface: ContactsInterface())
/// launchManager.add(handler: contactsHander, for: .contacts)
/// launchManager.setup()
/// ```
///
/// - note:
///   Launch environment for the handler can be set by the `ContactLaunchEnvironment`
///   from the [AutoMate](https://github.com/PGSSoft/AutoMate) project.
///
/// - note:
///   `ContactsHandler` should be used with the `AM_CONTACTS_KEY` key, but its implementation doesn't require to use it.
///   Any key provided to the `LaunchEnvironmentManager.add(handler:for:)` method will be handled correctly.
///
/// - seealso: `LaunchEnvironmentManager`
/// - seealso: `LaunchEnvironmentResource`
/// - seealso: `ContactParser`
/// - seealso: `ContactsInterface`
public struct ContactsHandler<C: ContactParser, I: ContactsInterface>: Handler {

    // MARK: Properties
    /// Contact parser, an instance of the `ContactParser` protocol.
    public let contactParser: C

    /// Contact interface, an instance of the `ContactsInterface` protocol.
    public let contactsInterface: I

    // MARK: Initialization
    /// Initialize this handler with parser (which transform `Dictionary` to `CNMutableContact`)
    /// and interface (which is responsible for interacting with `Contacts` framework).
    ///
    /// - Parameters:
    ///   - contactParser: Contact parser, an instance of type that conforms to the `ContactParser` protocol.
    ///     Responsible for transforing `Dictionary` to `CNMutableContact`.
    ///   - contactsInterface: Contact interface, an instance of type that conforms to the `ContactsInterface` protocol.
    ///     Responsible for interacting with `Contacts` framework
    public init(withParser contactParser: C, contactsInterface: I) {
        self.contactParser = contactParser
        self.contactsInterface = contactsInterface
    }

    // MARK: Methods
    /// Handles value for the `AM_CONTACTS_KEY` key and manage contacts.
    ///
    /// - Parameters:
    ///   - key: `AM_CONTACTS_KEY` / `AutoMateLaunchOptionKey.contacts`.
    ///   - value: `LaunchEnvironmentResource` resources representation as a string.
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
