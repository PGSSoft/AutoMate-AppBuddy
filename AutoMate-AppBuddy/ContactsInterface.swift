//
//  ContactsInterface.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 02/03/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

#if !os(tvOS)
import Contacts

/// Define metohods required to interact with `Contacts` framework.
///
/// - seealso: `ContactsInterface`
/// - seealso: `ContactsHandler`
public protocol ContactsInterfaceProtocol {
    /// This closure passes information about a complete asynchronous task.
    ///
    /// Depending on the outcome the error may be available, and the success flag changes its value.
    typealias CompletionBlock = (Bool, Error?) -> Void

    /// Adds all contacts to the `CNContactStore`.
    ///
    /// - Parameters:
    ///   - contacts: List of contacts.
    ///   - completion: Completion closure called after contacts were saved to the store.
    func addAll(_ contacts: [CNMutableContact], completion: @escaping CompletionBlock)

    /// Remove all contacts from the `CNContactStore`.
    ///
    /// - Parameter completion: Completion closure called after contacts were removed from the store.
    func removeAll(completion: @escaping CompletionBlock)

    /// Request access to the `Contacts` framework.
    ///
    /// - Parameter completion: Completion closure.
    func requestAccess(completion: @escaping CompletionBlock)
}

/// Provides a basic mechanism for interacting with the `Contacts` framework.
///
/// Conforms to the `ContactsInterfaceProtocol` protocol.
///
/// - seealso: `ContactsHandler`
public class ContactsInterface: ContactsInterfaceProtocol {

    // MARK: Properties
    private let contactStore: CNContactStore
    private var fetchRequest: CNContactFetchRequest = {
        return CNContactFetchRequest(keysToFetch: [
            CNContactEmailAddressesKey,
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactUrlAddressesKey,
            CNContactSocialProfilesKey,
            CNContactThumbnailImageDataKey,
            CNContactNicknameKey
        ].compactMap { $0 as? CNKeyDescriptor })
    }()

    // MARK: Initialization
    /// Initialize object with the `CNContactStore` and a fetch request.
    ///
    /// If the contact store is not provided a new one is created.
    /// The fetch request is used for contacts removal. If not provided, the default fetch request will be used
    /// which will match to all contacts on a device.
    ///
    /// - Parameters:
    ///   - contactStore: A contact store used to communicate.
    ///   - fetchRequest: A fetch request used for contacts removal.
    public init(contactStore: CNContactStore = CNContactStore(), fetchRequest: CNContactFetchRequest? = nil) {
        self.contactStore = contactStore
        self.fetchRequest ?= fetchRequest
    }

    // MARK: Methods
    /// Adds all contacts to the `CNContactStore`.
    ///
    /// - Parameters:
    ///   - contacts: List of contacts.
    ///   - completion: Completion closure called after contacts were saved to the store.
    public func addAll(_ contacts: [CNMutableContact], completion: @escaping ContactsInterfaceProtocol.CompletionBlock) {
        do {
            let saveRequest = CNSaveRequest()
            contacts.forEach { saveRequest.add($0, toContainerWithIdentifier: nil) }
            try contactStore.execute(saveRequest)
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }

    /// Remove all contacts from the `CNContactStore`.
    ///
    /// - Parameter completion: Completion closure called after contacts were removed from the store.
    public func removeAll(completion: @escaping ContactsInterfaceProtocol.CompletionBlock) {
        do {
            let saveRequest = CNSaveRequest()
            var contacts = [CNContact]()
            try contactStore.enumerateContacts(with: fetchRequest) { contact, _ in contacts.append(contact) }

            contacts.compactMap { $0.mutableCopy() as? CNMutableContact }.forEach { saveRequest.delete($0) }
            try contactStore.execute(saveRequest)
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }

    /// Request access to the `Contacts` framework.
    ///
    /// - Parameter completion: Completion closure.
    public func requestAccess(completion: @escaping ContactsInterfaceProtocol.CompletionBlock) {
        contactStore.requestAccess(for: .contacts, completionHandler: completion)
    }
}

#endif
