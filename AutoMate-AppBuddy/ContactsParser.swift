//
//  ContactsParser.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 16.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Contacts

// MARK: - Contact Parser
/// Extension to the `Parser` protocol.
/// Requires the converted object to be an instance of the `CNMutableContact` type.
///
/// - seealso: `ContactDictionaryParser`
/// - seealso: `ContactsHandler`
public protocol ContactParser: Parser {

    // MARK: Typealiases
    typealias T = Any
    typealias U = CNMutableContact

    // MARK: Properties
    /// Contact store used for saving contacts.
    var store: CNContactStore { get }
}

public extension ContactParser {

    /// Reads JSON arrays from `LaunchEnvironmentResource` then parse the data
    /// to `CNMutableContact`s and save them to the `CNContactStore`.
    ///
    /// - Parameter resources: An array of resources describing a path to data to parse.
    /// - Throws: `ParserError` if data has unexpected format or standard `Error` for saving and committing in CNContactStore.
    public func parseAndSave(resources: [LaunchEnvironmentResource]) throws {
        let saveRequest = CNSaveRequest()
        try parsed(resources: resources).forEach { saveRequest.add($0, toContainerWithIdentifier: nil) }
        try store.execute(saveRequest)
    }
}

// MARK: - Contact Dictionary Parser
/// Default implementation of the `ContactParser` protocol.
///
/// Parse contact data from json. Each key from JSON represents property name from `CNMutableContact` type.
///
/// **Example:**
///
/// ```json
/// {
///   "contactType": "person",
///   "givenName": "Michael"
/// }
/// ```
///
/// `DateComponents` is represented as a JSON dictionary:
///
/// **Example:**
///
/// ```json
/// {
///   "birthday": {
///     "year": 2016,
///     "month": 5,
///     "day": 19
///   }
/// }
/// ```
///
/// `CNLabeledValue` is represented as a JSON dictionary.
/// The dictionary key is used as `label`.
/// The value from the dictionary for the key is used as `value`.
///
/// **Example:**
///
/// ```json
/// {
///   "date1": {
///     "year": 2017,
///     "month": 2,
///     "day": 17
///   }
/// }
/// ```
///
/// Dates, social profiles, phone numbers, email addresses, url addresses,
/// postal addresses, contact relationships and instant message addresses
/// are constructed as a list of dictionaries.
///
/// **Example:** 
///
/// ```json
/// {
///   "phoneNumbers": [
///     {
///       "work": {
///         "stringValue": "0 1234567890"
///       }
///     },
///     {
///       "mobile": {
///         "stringValue": "0 1234567890"
///       }
///     },
///     {
///       "nil": {
///         "stringValue": "0 1234567890"
///       }
///     }
///   ]
/// }
/// ```
///
/// - note:
///   `"nil"` in the dictionary keys are converted to `nil` value.
///
/// - seealso: `ContactsHandler`
/// - seealso: For full example check `contacts.json` file in the test project.
public struct ContactDictionaryParser: ContactParser {

    // MARK: Properties
    /// Contact store used for saving contacts.
    public var store: CNContactStore

    // MARK: Initialization
    /// Initialize parser with contact store.
    ///
    /// - Parameter store: Contact store used for saving contacts.
    public init(with store: CNContactStore = CNContactStore()) {
        self.store = store
    }

    // MARK: Public methods
    /// Parse JSON dictionary (represented as `Any`) and return parsed contact object.
    ///
    /// - Parameter data: JSON dictionary to parse.
    /// - Returns: Parsed contact.
    /// - Throws: `ParserError` if the provided data are not of a type `[String: Any]`.
    public func parse(_ data: Any) throws -> CNMutableContact {
        guard let jsonDict = data as? [String: Any] else {
            throw ParserError(message: "Expected dictionary, given \(data)")
        }

        let contact = CNMutableContact()
        try contact.parse(from: jsonDict)
        return contact
    }
}
