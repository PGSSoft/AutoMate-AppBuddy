//
//  ContactsParser.swift
//  AutoMate App Companion
//
//  Created by Bartosz Janda on 16.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Contacts

// MARK: - Contact Parser
public protocol ContactParser: Parser {

    // MARK: Typealiases
    typealias T = Any
    typealias U = CNMutableContact

    // MARK: Properties
    var store: CNContactStore { get }
}

public extension ContactParser {

    /// Will access all
    ///
    /// - Parameter resources: Array of resources describing path to events data.
    /// - Throws: `ParserError` if data has unexpected format or standard `Error` for saving and commiting in CNContactStore.
    public func parseAndSave(resources: [LaunchEnvironmentResource]) throws {
        let saveRequest = CNSaveRequest()
        try parsed(resources: resources).forEach { saveRequest.add($0, toContainerWithIdentifier: nil) }
        try store.execute(saveRequest)
    }
}

// MARK: - Contact Dictionary Parser
public struct ContactDictionaryParser: ContactParser {

    // MARK: Properties
    public var store: CNContactStore

    // MARK: Initialization
    public init(with store: CNContactStore = CNContactStore()) {
        self.store = store
    }

    // MARK: Public methods
    public func parse(_ data: Any) throws -> CNMutableContact {
        guard let jsonDict = data as? [String: Any] else {
            throw ParserError(message: "Expected dictionary, given \(data)")
        }

        let contact = CNMutableContact()
        try contact.parse(from: jsonDict)
        return contact
    }
}
