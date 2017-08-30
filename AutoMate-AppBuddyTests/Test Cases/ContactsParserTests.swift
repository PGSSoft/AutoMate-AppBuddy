//
//  ContactsParserTests.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 16.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
import Contacts
@testable import AutoMate_AppBuddy

extension Optional: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none: return "nil"
        case let .some(value): return "\(value)"
        }
    }
}

// swiftlint:disable type_body_length file_length
class ContactsParserTests: XCTestCase {

    // MARK: Properties
    let store = CNContactStore()
    lazy var contactParser: ContactDictionaryParser = ContactDictionaryParser(with: self.store)

    // MARK: Tests
    func testContanctTypeParser() {
        XCTAssertEqual(try CNContactType.parse(from: "person"), .person)
        XCTAssertEqual(try CNContactType.parse(from: "organization"), .organization)
        assertThrows(expr: _ = try CNContactType.parse(from: "Person"), errorType: ParserError.self, "The value \"Person\" could not be transformed.")
    }

    func testSocialProfile() {
        XCTAssertEqual(
            try CNSocialProfile.parse(from: [:]),
            CNSocialProfile(
                urlString: nil,
                username: nil,
                userIdentifier: nil,
                service: nil)
        )

        XCTAssertEqual(
            try CNSocialProfile.parse(from: [
                "urlString": "http://url",
                "service": "SomethingElse"]),
            CNSocialProfile(
                urlString: "http://url",
                username: nil,
                userIdentifier: nil,
                service: "SomethingElse")
        )

        XCTAssertEqual(
            try CNSocialProfile.parse(from: [
                "urlString": "http://url",
                "username": "UserName",
                "userIdentifier": "1234567890",
                "service": "facebook"]),
            CNSocialProfile(
                urlString: "http://url",
                username: "UserName",
                userIdentifier: "1234567890",
                service: CNSocialProfileServiceFacebook)
        )
    }

    func testSocialProfileService() {
        XCTAssertEqual(Either<SocialProfileService>(string: "facebook").stringValue, CNSocialProfileServiceFacebook)
        XCTAssertEqual(Either<SocialProfileService>(string: "flicker").stringValue, CNSocialProfileServiceFlickr)
        XCTAssertEqual(Either<SocialProfileService>(string: "linkedIn").stringValue, CNSocialProfileServiceLinkedIn)
        XCTAssertEqual(Either<SocialProfileService>(string: "mySpace").stringValue, CNSocialProfileServiceMySpace)
        XCTAssertEqual(Either<SocialProfileService>(string: "sinaWeibo").stringValue, CNSocialProfileServiceSinaWeibo)
        XCTAssertEqual(Either<SocialProfileService>(string: "tencentWeibo").stringValue, CNSocialProfileServiceTencentWeibo)
        XCTAssertEqual(Either<SocialProfileService>(string: "twitter").stringValue, CNSocialProfileServiceTwitter)
        XCTAssertEqual(Either<SocialProfileService>(string: "yelp").stringValue, CNSocialProfileServiceYelp)
        XCTAssertEqual(Either<SocialProfileService>(string: "gameCenter").stringValue, CNSocialProfileServiceGameCenter)
        XCTAssertEqual(Either<SocialProfileService>(string: "SomethingElse").stringValue, "SomethingElse")
        XCTAssertEqual(Either<SocialProfileService>(string: "My Space").stringValue, "My Space")
        XCTAssertEqual(Either<SocialProfileService>(string: "Sina Weibo").stringValue, "Sina Weibo")
        XCTAssertEqual(Either<SocialProfileService>(string: "Game Center").stringValue, "Game Center")
    }

    func testPhoneNumber() {
        XCTAssertNil(try? CNPhoneNumber.parse(from: [:]))
        XCTAssertEqual(try CNPhoneNumber.parse(from: ["stringValue": "1234567890"]), CNPhoneNumber(stringValue: "1234567890"))
    }

    func testPhoneNumberLabels() {
        XCTAssertEqual(Either<PhoneNumberLabels>(string: "iPhone").stringValue, CNLabelPhoneNumberiPhone)
        XCTAssertEqual(Either<PhoneNumberLabels>(string: "mobile").stringValue, CNLabelPhoneNumberMobile)
        XCTAssertEqual(Either<PhoneNumberLabels>(string: "main").stringValue, CNLabelPhoneNumberMain)
        XCTAssertEqual(Either<PhoneNumberLabels>(string: "homeFax").stringValue, CNLabelPhoneNumberHomeFax)
        XCTAssertEqual(Either<PhoneNumberLabels>(string: "workFax").stringValue, CNLabelPhoneNumberWorkFax)
        XCTAssertEqual(Either<PhoneNumberLabels>(string: "otherFax").stringValue, CNLabelPhoneNumberOtherFax)
        XCTAssertEqual(Either<PhoneNumberLabels>(string: "pager").stringValue, CNLabelPhoneNumberPager)
        XCTAssertEqual(Either<PhoneNumberLabels>(string: "Private").stringValue, "Private")
    }

    func testPostalAddress() {
        XCTAssertEqual(try CNMutablePostalAddress.parse(from: [:]), CNMutablePostalAddress())

        let postalAddress1 = CNMutablePostalAddress()
        postalAddress1.street = "Street"
        postalAddress1.city = "CityName"
        postalAddress1.state = "State"
        postalAddress1.postalCode = "ASD1234"
        postalAddress1.country = "Some Country"
        postalAddress1.isoCountryCode = "XYZ"
        XCTAssertEqual(
            try CNMutablePostalAddress.parse(from: [
                "street": "Street",
                "city": "CityName",
                "state": "State",
                "postalCode": "ASD1234",
                "country": "Some Country",
                "isoCountryCode": "XYZ"]),
            postalAddress1)
    }

    func testContactRelation() {
        XCTAssertNil(try? CNContactRelation.parse(from: [:]))
        XCTAssertEqual(try CNContactRelation.parse(from: ["name": "John"]), CNContactRelation(name: "John"))
    }

    func testRelatedContactsLabels() {
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "father").stringValue, CNLabelContactRelationFather)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "mother").stringValue, CNLabelContactRelationMother)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "parent").stringValue, CNLabelContactRelationParent)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "brother").stringValue, CNLabelContactRelationBrother)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "sister").stringValue, CNLabelContactRelationSister)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "child").stringValue, CNLabelContactRelationChild)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "friend").stringValue, CNLabelContactRelationFriend)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "spouse").stringValue, CNLabelContactRelationSpouse)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "partner").stringValue, CNLabelContactRelationPartner)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "assistant").stringValue, CNLabelContactRelationAssistant)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "manager").stringValue, CNLabelContactRelationManager)
        XCTAssertEqual(Either<RelatedContactsLabels>(string: "Twin").stringValue, "Twin")
    }

    func testInstantMessageAddress() {
        XCTAssertNil(try? CNInstantMessageAddress.parse(from: [:]))
        XCTAssertEqual(try CNInstantMessageAddress.parse(from: ["username": "John", "service": "skype"]), CNInstantMessageAddress(username: "John", service: CNInstantMessageServiceSkype))
        XCTAssertEqual(try CNInstantMessageAddress.parse(from: ["username": "Henry", "service": "Slack"]), CNInstantMessageAddress(username: "Henry", service: "Slack"))
    }

    func testInstantMessageServices() {
        XCTAssertEqual(Either<InstantMessageServices>(string: "aim").stringValue, CNInstantMessageServiceAIM)
        XCTAssertEqual(Either<InstantMessageServices>(string: "facebook").stringValue, CNInstantMessageServiceFacebook)
        XCTAssertEqual(Either<InstantMessageServices>(string: "gaduGadu").stringValue, CNInstantMessageServiceGaduGadu)
        XCTAssertEqual(Either<InstantMessageServices>(string: "googleTalk").stringValue, CNInstantMessageServiceGoogleTalk)
        XCTAssertEqual(Either<InstantMessageServices>(string: "icq").stringValue, CNInstantMessageServiceICQ)
        XCTAssertEqual(Either<InstantMessageServices>(string: "jabber").stringValue, CNInstantMessageServiceJabber)
        XCTAssertEqual(Either<InstantMessageServices>(string: "msn").stringValue, CNInstantMessageServiceMSN)
        XCTAssertEqual(Either<InstantMessageServices>(string: "qq").stringValue, CNInstantMessageServiceQQ)
        XCTAssertEqual(Either<InstantMessageServices>(string: "skype").stringValue, CNInstantMessageServiceSkype)
        XCTAssertEqual(Either<InstantMessageServices>(string: "yahoo").stringValue, CNInstantMessageServiceYahoo)
        XCTAssertEqual(Either<InstantMessageServices>(string: "Slack").stringValue, "Slack")
    }

    func testParseContactWithMinimalInfo() {
        let contactDict = ContactsFactory.contactWithMinimalInformations
        var contact: CNMutableContact!
        assertNotThrows(expr: contact = try contactParser.parse(contactDict), "Parser failed for \(contactDict).")
        assert(contact: contact, with: contactDict)
    }

    func testParseContactWithAllInfo() {
        let contactDict = ContactsFactory.contactWithAllInformations
        var contact: CNMutableContact!
        assertNotThrows(expr: contact = try contactParser.parse(contactDict), "Parser failed for \(contactDict).")
        assert(contact: contact, with: contactDict)
    }

    func testParseContactFromJSONFile() {
        var contacts = [CNMutableContact]()
        let resource = LaunchEnvironmentResource(bundle: "com.pgs-soft.AutoMate-AppBuddyTests", name: "contacts")!
        assertNotThrows(expr: contacts = try contactParser.parsed(resources: [resource]), "Data format corrupted")
        XCTAssertEqual(contacts.count, 2)
    }

    // MARK: Helpers
    func assert(contact: CNContact, with dictionary: [String: Any], file: StaticString = #file, line: UInt = #line) {
        assert(contactType: contact.contactType, isEqual: dictionary["contactType"], file: file, line: line)
        assert(dateComponents: contact.birthday, isEqual: dictionary["birthday"], file: file, line: line)
        assert(dateComponents: contact.nonGregorianBirthday, isEqual: dictionary["nonGregorianBirthday"], file: file, line: line)
        assert(dates: contact.dates, isEqual: dictionary["dates"], file: file, line: line)
        assert(contact.namePrefix, isEqual: dictionary["namePrefix"] ?? "", file: file, line: line)
        assert(contact.givenName, isEqual: dictionary["givenName"] ?? "", file: file, line: line)
        assert(contact.middleName, isEqual: dictionary["middleName"] ?? "", file: file, line: line)
        assert(contact.familyName, isEqual: dictionary["familyName"] ?? "", file: file, line: line)
        assert(contact.previousFamilyName, isEqual: dictionary["previousFamilyName"] ?? "", file: file, line: line)
        assert(contact.nameSuffix, isEqual: dictionary["nameSuffix"] ?? "", file: file, line: line)
        assert(contact.nickname, isEqual: dictionary["nickname"] ?? "", file: file, line: line)
        assert(contact.phoneticGivenName, isEqual: dictionary["phoneticGivenName"] ?? "", file: file, line: line)
        assert(contact.phoneticMiddleName, isEqual: dictionary["phoneticMiddleName"] ?? "", file: file, line: line)
        assert(contact.phoneticFamilyName, isEqual: dictionary["phoneticFamilyName"] ?? "", file: file, line: line)
        assert(contact.organizationName, isEqual: dictionary["organizationName"] ?? "", file: file, line: line)
        assert(contact.departmentName, isEqual: dictionary["departmentName"] ?? "", file: file, line: line)
        assert(contact.jobTitle, isEqual: dictionary["jobTitle"] ?? "", file: file, line: line)
        assert(socialProfiles: contact.socialProfiles, isEqual: dictionary["socialProfiles"], file: file, line: line)
        assert(phoneNumbers: contact.phoneNumbers, isEqual: dictionary["phoneNumbers"], file: file, line: line)
        assert(strings: contact.urlAddresses, isEqual: dictionary["urlAddresses"], file: file, line: line)
        assert(postalAddresses: contact.postalAddresses, isEqual: dictionary["postalAddresses"], file: file, line: line)
        assert(strings: contact.emailAddresses, isEqual: dictionary["emailAddresses"], file: file, line: line)
        assert(contact.note, isEqual: dictionary["note"] ?? "", file: file, line: line)
        assert(imageData: contact.imageData, isEqual: dictionary["imageData"], file: file, line: line)
        assert(contactRelations: contact.contactRelations, isEqual: dictionary["contactRelations"], file: file, line: line)
        assert(instantMessageAddresses: contact.instantMessageAddresses, isEqual: dictionary["instantMessageAddresses"], file: file, line: line)
        if #available(iOS 10.0, *) {
            assert(contact.phoneticOrganizationName, isEqual: dictionary["phoneticOrganizationName"] ?? "", file: file, line: line)
        }
    }

    func assert(contactType: CNContactType, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTFail("`contactType` cannot be empty.", file: file, line: line)
        case let expectedT as String:
            let contactTypeT = try? CNContactType.parse(from: expectedT)
            XCTAssertEqual(contactType, contactTypeT, "Value \(contactType) is not equal to \(expectedT)", file: file, line: line)
        default:
            XCTFail("Types \(contactType) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    func assert(dates: [CNLabeledValue<NSDateComponents>], isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        // Special case
        guard expected != nil || dates.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(dates) and \(expected.debugDescription) do not match.", file: file, line: line)
            return
        }

        XCTAssertEqual(dates.count, expectedT.count, file: file, line: line)
        guard dates.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let date = dates[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key", file: file, line: line)
                continue
            }

            XCTAssertEqual(date.label, key != "nil" ? key : nil, file: file, line: line)
            assert(dateComponents: date.value, isEqual: expected[key], file: file, line: line)
        }
    }

    func assert(socialProfiles: [CNLabeledValue<CNSocialProfile>], isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        // Special case
        guard expected != nil || socialProfiles.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(socialProfiles) and \(expected.debugDescription) do not match.", file: file, line: line)
            return
        }

        XCTAssertEqual(socialProfiles.count, expectedT.count, file: file, line: line)
        guard socialProfiles.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let socialProfile = socialProfiles[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key", file: file, line: line)
                continue
            }

            XCTAssertEqual(socialProfile.label, key != "nil" ? key : nil, file: file, line: line)
            assert(socialProfile: socialProfile.value, isEqual: expected[key], file: file, line: line)
        }
    }

    func assert(socialProfile: CNSocialProfile, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTFail("`socialProfile` cannot be empty.", file: file, line: line)
        case let expectedT as [String: Any]:
            let socialProfileT = try? CNSocialProfile.parse(from: expectedT)
            XCTAssertEqual(socialProfile, socialProfileT, "Value \(socialProfile) is not equal to \(expectedT)", file: file, line: line)
        default:
            XCTFail("Types \(socialProfile) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    func assert(phoneNumbers: [CNLabeledValue<CNPhoneNumber>], isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        // Special case
        guard expected != nil || phoneNumbers.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(phoneNumbers) and \(expected.debugDescription) do not match.", file: file, line: line)
            return
        }

        XCTAssertEqual(phoneNumbers.count, expectedT.count, file: file, line: line)
        guard phoneNumbers.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let phoneNumber = phoneNumbers[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key", file: file, line: line)
                continue
            }

            let label = Either<PhoneNumberLabels>(string: key).stringValue
            XCTAssertEqual(phoneNumber.label, label != "nil" ? label : nil, file: file, line: line)
            assert(phoneNumber: phoneNumber.value, isEqual: expected[key], file: file, line: line)
        }
    }

    func assert(phoneNumber: CNPhoneNumber, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTFail("`phoneNumber` cannot be empty.", file: file, line: line)
        case let expectedT as [String: Any]:
            let phoneNumberT = try? CNPhoneNumber.parse(from: expectedT)
            XCTAssertEqual(phoneNumber, phoneNumberT, "Value \(phoneNumber) is not equal to \(expectedT)", file: file, line: line)
        default:
            XCTFail("Types \(phoneNumber) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    func assert(strings: [CNLabeledValue<NSString>], isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        // Special case
        guard expected != nil || strings.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: NSString]] else {
            XCTFail("Types \(strings) and \(expected.debugDescription) do not match.", file: file, line: line)
            return
        }

        XCTAssertEqual(strings.count, expectedT.count, file: file, line: line)
        guard strings.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let string = strings[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key", file: file, line: line)
                continue
            }

            XCTAssertEqual(string.label, key != "nil" ? key : nil, file: file, line: line)
            XCTAssertEqual(string.value, expected[key], file: file, line: line)
        }
    }

    func assert(postalAddresses: [CNLabeledValue<CNPostalAddress>], isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        // Special case
        guard expected != nil || postalAddresses.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(postalAddresses) and \(expected.debugDescription) do not match.", file: file, line: line)
            return
        }

        XCTAssertEqual(postalAddresses.count, expectedT.count, file: file, line: line)
        guard postalAddresses.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let postalAddress = postalAddresses[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key", file: file, line: line)
                continue
            }

            XCTAssertEqual(postalAddress.label, key != "nil" ? key : nil, file: file, line: line)
            assert(postalAddress: postalAddress.value, isEqual: expected[key])
        }
    }

    func assert(postalAddress: CNPostalAddress, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTFail("`postalAddress` cannot be empty.", file: file, line: line)
        case let expectedT as [String: Any]:
            let postalAddressT = try? CNMutablePostalAddress.parse(from: expectedT)
            XCTAssertEqual(postalAddress, postalAddressT, "Value \(postalAddress) is not equal to \(expectedT)", file: file, line: line)
        default:
            XCTFail("Types \(postalAddress) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    func assert(imageData: Data?, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTAssertNil(imageData, "Argument is \(imageData.debugDescription) while expected is .none.", file: file, line: line)
        case let expectedT as String:
            guard let resource = LaunchEnvironmentResource.resource(from: expectedT),
                let data = resource.bundle.data(with: resource.name) else {
                XCTFail("Cannot find resource \(expectedT)")
                return
            }
            XCTAssertEqual(imageData, data, "Value \(imageData.debugDescription) is not equal to \(expectedT)", file: file, line: line)
        default:
            XCTFail("Types \(imageData.debugDescription) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    func assert(contactRelations: [CNLabeledValue<CNContactRelation>], isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        // Special case
        guard expected != nil || contactRelations.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(contactRelations) and \(expected.debugDescription) do not match.", file: file, line: line)
            return
        }

        XCTAssertEqual(contactRelations.count, expectedT.count, file: file, line: line)
        guard contactRelations.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let contactRelation = contactRelations[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key", file: file, line: line)
                continue
            }

            let label = Either<RelatedContactsLabels>(string: key).stringValue
            XCTAssertEqual(contactRelation.label, label != "nil" ? label : nil, file: file, line: line)
            assert(contactRelation: contactRelation.value, isEqual: expected[key], file: file, line: line)
        }
    }

    func assert(contactRelation: CNContactRelation, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTFail("`contactRelation` cannot be empty.", file: file, line: line)
        case let expectedT as [String: Any]:
            let contactRelationT = try? CNContactRelation.parse(from: expectedT)
            XCTAssertEqual(contactRelation, contactRelationT, "Value \(contactRelation) is not equal to \(expectedT)", file: file, line: line)
        default:
            XCTFail("Types \(contactRelation) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }

    func assert(instantMessageAddresses: [CNLabeledValue<CNInstantMessageAddress>], isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        // Special case
        guard expected != nil || instantMessageAddresses.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(instantMessageAddresses) and \(expected.debugDescription) do not match.", file: file, line: line)
            return
        }

        XCTAssertEqual(instantMessageAddresses.count, expectedT.count, file: file, line: line)
        guard instantMessageAddresses.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let instantMessageAddress = instantMessageAddresses[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key", file: file, line: line)
                continue
            }

            XCTAssertEqual(instantMessageAddress.label, key != "nil" ? key : nil, file: file, line: line)
            assert(instantMessageAddress: instantMessageAddress.value, isEqual: expected[key], file: file, line: line)
        }
    }

    func assert(instantMessageAddress: CNInstantMessageAddress, isEqual expected: Any?, file: StaticString = #file, line: UInt = #line) {
        switch expected {
        case .none:
            XCTFail("`contactRelation` cannot be empty.", file: file, line: line)
        case let expectedT as [String: Any]:
            let instantMessageAddressT = try? CNInstantMessageAddress.parse(from: expectedT)
            XCTAssertEqual(instantMessageAddress, instantMessageAddressT, "Value \(instantMessageAddress) is not equal to \(expectedT)", file: file, line: line)
        default:
            XCTFail("Types \(instantMessageAddress) and \(expected.debugDescription) do not match.", file: file, line: line)
        }
    }
}
