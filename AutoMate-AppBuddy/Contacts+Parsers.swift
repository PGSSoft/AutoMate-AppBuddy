//
//  Contacts+Parsers.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 16.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

// swiftlint:disable file_length

import Foundation
import Contacts

// MARK: - CNContactType
internal extension CNContactType {

    static func parse(from string: String) throws -> CNContactType {
        switch string {
        case "person": return .person
        case "organization": return .organization
        default: throw ParserError(message: "The value \"\(string)\" could not be transformed.")
        }
    }
}

// MARK: - CNSocialProfile
extension CNSocialProfile {
    static func parse(from data: [String: Any]) throws -> CNSocialProfile {
        return CNSocialProfile(urlString: try data.fetchOptional("urlString"),
                               username: try data.fetchOptional("username"),
                               userIdentifier: try data.fetchOptional("userIdentifier"),
                               service: try? Either<SocialProfileService>(string: data.fetch("service")).stringValue
        )
    }
}

// MARK: - CNPhoneNumber
extension CNPhoneNumber {
    static func parse(from data: [String: Any]) throws -> CNPhoneNumber {
        return CNPhoneNumber(stringValue: try data.fetch("stringValue"))
    }
}

// MARK: - CNMutablePostalAddress
extension CNMutablePostalAddress {
    static func parse(from data: [String: Any]) throws -> CNMutablePostalAddress {
        let address = CNMutablePostalAddress()
        address.street ?= try data.fetchOptional("street")
        address.city ?= try data.fetchOptional("city")
        address.state ?= try data.fetchOptional("state")
        address.postalCode ?= try data.fetchOptional("postalCode")
        address.country ?= try data.fetchOptional("country")
        address.isoCountryCode ?= try data.fetchOptional("isoCountryCode")
        return address
    }
}

// MARK: - CNContactRelation
extension CNContactRelation {
    static func parse(from data: [String: Any]) throws -> CNContactRelation {
        return CNContactRelation(name: try data.fetch("name"))
    }
}

// MARK: - CNInstantMessageAddress
extension CNInstantMessageAddress {
    static func parse(from data: [String: Any]) throws -> CNInstantMessageAddress {
        return CNInstantMessageAddress(
            username: try data.fetch("username"),
            service: Either<InstantMessageServices>(string: try data.fetch("service")).stringValue
        )
    }
}

// MARK: - CNMutableContact
internal extension CNMutableContact {
    func parse(from data: [String: Any]) throws {
        contactType = try data.fetch("contactType") { try CNContactType.parse(from: $0) }
        dates ?= try data.fetchOptionalArray("dates") { try parse(dates: $0) }
        birthday = try data.fetchOptional("birthday") { try DateComponents.parse(from: $0) }
        nonGregorianBirthday = try data.fetchOptional("nonGregorianBirthday") { try DateComponents.parse(from: $0) }
        namePrefix ?= try data.fetchOptional("namePrefix")
        givenName ?= try data.fetchOptional("givenName")
        middleName ?= try data.fetchOptional("middleName")
        familyName ?= try data.fetchOptional("familyName")
        previousFamilyName ?= try data.fetchOptional("previousFamilyName")
        nameSuffix ?= try data.fetchOptional("nameSuffix")
        nickname ?= try data.fetchOptional("nickname")
        phoneticGivenName ?= try data.fetchOptional("phoneticGivenName")
        phoneticMiddleName ?= try data.fetchOptional("phoneticMiddleName")
        phoneticFamilyName ?= try data.fetchOptional("phoneticFamilyName")
        organizationName ?= try data.fetchOptional("organizationName")
        phoneticOrganizationName ?= try data.fetchOptional("phoneticOrganizationName")
        departmentName ?= try data.fetchOptional("departmentName")
        jobTitle ?= try data.fetchOptional("jobTitle")
        socialProfiles ?= try data.fetchOptionalArray("socialProfiles") { try parse(socialProfiles:$0) }
        phoneNumbers ?= try data.fetchOptionalArray("phoneNumbers") { try parse(phoneNumbers:$0) }
        emailAddresses ?= try data.fetchOptionalArray("emailAddresses") { try parse(strings:$0) }
        urlAddresses ?= try data.fetchOptionalArray("urlAddresses") { try parse(strings:$0) }
        postalAddresses ?= try data.fetchOptionalArray("postalAddresses") { try parse(postalAddresses:$0) }
        note ?= try data.fetchOptional("note")
        imageData = try data.fetchOptional("imageData") { try parse(image:$0) }
        contactRelations ?= try data.fetchOptionalArray("contactRelations") { try parse(contactRelations:$0) }
        instantMessageAddresses ?= try data.fetchOptionalArray("instantMessageAddresses") { try parse(instantMessageAddresses:$0) }
    }

    private func normalized(key: String) -> String? {
        return key != "nil" ? key : nil
    }

    private func parse(dates: [String: [String: Any]]) throws -> CNLabeledValue<NSDateComponents> {
        return try dates.fetchFirst { CNLabeledValue(label: normalized(key: $0), value: try NSDateComponents.parse(from: $1)) }
    }

    private func parse(socialProfiles: [String: [String: Any]]) throws -> CNLabeledValue<CNSocialProfile> {
        return try socialProfiles.fetchFirst { CNLabeledValue(label: normalized(key: $0), value: try CNSocialProfile.parse(from: $1)) }
    }

    private func parse(phoneNumbers: [String: [String: Any]]) throws -> CNLabeledValue<CNPhoneNumber> {
        return try phoneNumbers.fetchFirst { CNLabeledValue(label: normalized(key: Either<PhoneNumberLabels>(string: $0).stringValue), value: try CNPhoneNumber.parse(from: $1)) }
    }

    private func parse(strings: [String: NSString]) throws -> CNLabeledValue<NSString> {
        return try strings.fetchFirst { CNLabeledValue(label: normalized(key: $0), value: $1) }
    }

    private func parse(postalAddresses: [String: [String: Any]]) throws -> CNLabeledValue<CNPostalAddress> {
        return try postalAddresses.fetchFirst { CNLabeledValue(label: normalized(key: $0), value: try CNMutablePostalAddress.parse(from: $1)) }
    }

    private func parse(image: String) throws -> Data {
        guard let resource = LaunchEnvironmentResource.resource(from: image),
            let data = resource.bundle.data(with: resource.name) else {
            throw ParserError(message: "Cannot read image \(image)")
        }

        return data
    }

    private func parse(contactRelations: [String: [String: Any]]) throws -> CNLabeledValue<CNContactRelation> {
        return try contactRelations.fetchFirst { CNLabeledValue(label: normalized(key: Either<RelatedContactsLabels>(string: $0).stringValue), value: try CNContactRelation.parse(from: $1)) }
    }

    private func parse(instantMessageAddresses: [String: [String: Any]]) throws -> CNLabeledValue<CNInstantMessageAddress> {
        return try instantMessageAddresses.fetchFirst { CNLabeledValue(label: normalized(key: $0), value: try CNInstantMessageAddress.parse(from: $1)) }
    }
}

// MARK: - ?= operator
precedencegroup OptionalAssignment {
    associativity: right
    assignment: true
}

infix operator ?= : OptionalAssignment

public func ?= <T>(variable: inout T, value: T?) {
    if let value = value {
        variable = value
    }
}
