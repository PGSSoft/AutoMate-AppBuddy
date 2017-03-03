//
//  ContactsInterface.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 02/03/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Contacts

public protocol ContactsInterfaceProtocol {
    typealias CompletionBlock = (Bool, Error?) -> Void
    func addAll(_ contacts: [CNMutableContact], completion: @escaping CompletionBlock)
    func removeAll(completion: @escaping CompletionBlock)
    func requestAccess(completion: @escaping CompletionBlock)
}

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
                                     ].flatMap { $0 as? CNKeyDescriptor })
    }()

    // MARK: Initialization
    public init(contactStore: CNContactStore = CNContactStore(), fetchRequest: CNContactFetchRequest? = nil) {
        self.contactStore = contactStore
        self.fetchRequest ?= fetchRequest
    }

    // MARK: Methods
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

    public func removeAll(completion: @escaping ContactsInterfaceProtocol.CompletionBlock) {
        do {
            let saveRequest = CNSaveRequest()
            var contacts = [CNContact]()
            try contactStore.enumerateContacts(with: fetchRequest) { contacts.append($0.0) }

            contacts.flatMap { $0 as? CNMutableContact }.forEach { saveRequest.delete($0) }
            try contactStore.execute(saveRequest)
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }

    public func requestAccess(completion: @escaping ContactsInterfaceProtocol.CompletionBlock) {
        contactStore.requestAccess(for: .contacts, completionHandler: completion)
    }
}
