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
    func assert(contact: CNContact, with dictionary: [String: Any]) {
        assert(contactType: contact.contactType, isEqual: dictionary["contactType"])
        assert(dateComponents: contact.birthday, isEqual: dictionary["birthday"])
        assert(dateComponents: contact.nonGregorianBirthday, isEqual: dictionary["nonGregorianBirthday"])
        assert(dates: contact.dates, isEqual: dictionary["dates"])
        assert(contact.namePrefix, isEqual: dictionary["namePrefix"] ?? "")
        assert(contact.givenName, isEqual: dictionary["givenName"] ?? "")
        assert(contact.middleName, isEqual: dictionary["middleName"] ?? "")
        assert(contact.familyName, isEqual: dictionary["familyName"] ?? "")
        assert(contact.previousFamilyName, isEqual: dictionary["previousFamilyName"] ?? "")
        assert(contact.nameSuffix, isEqual: dictionary["nameSuffix"] ?? "")
        assert(contact.nickname, isEqual: dictionary["nickname"] ?? "")
        assert(contact.phoneticGivenName, isEqual: dictionary["phoneticGivenName"] ?? "")
        assert(contact.phoneticMiddleName, isEqual: dictionary["phoneticMiddleName"] ?? "")
        assert(contact.phoneticFamilyName, isEqual: dictionary["phoneticFamilyName"] ?? "")
        assert(contact.organizationName, isEqual: dictionary["organizationName"] ?? "")
        assert(contact.departmentName, isEqual: dictionary["departmentName"] ?? "")
        assert(contact.jobTitle, isEqual: dictionary["jobTitle"] ?? "")
        assert(socialProfiles: contact.socialProfiles, isEqual: dictionary["socialProfiles"])
        assert(phoneNumbers: contact.phoneNumbers, isEqual: dictionary["phoneNumbers"])
        assert(strings: contact.urlAddresses, isEqual: dictionary["urlAddresses"])
        assert(postalAddresses: contact.postalAddresses, isEqual: dictionary["postalAddresses"])
        assert(strings: contact.emailAddresses, isEqual: dictionary["emailAddresses"])
        assert(contact.note, isEqual: dictionary["note"] ?? "")
        assert(imageData: contact.imageData, isEqual: dictionary["imageData"])
        assert(contactRelations: contact.contactRelations, isEqual: dictionary["contactRelations"])
        assert(instantMessageAddresses: contact.instantMessageAddresses, isEqual: dictionary["instantMessageAddresses"])
        if #available(iOS 10.0, *) {
            assert(contact.phoneticOrganizationName, isEqual: dictionary["phoneticOrganizationName"] ?? "")
        }
    }

    func assert(contactType: CNContactType, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTFail("`contactType` cannot be empty.")
        case let expectedT as String:
            let contactTypeT = try? CNContactType.parse(from: expectedT)
            XCTAssertEqual(contactType, contactTypeT, "Value \(contactType) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(contactType) and \(String(describing: expected)) do not match.")
        }
    }

    func assert(dates: [CNLabeledValue<NSDateComponents>], isEqual expected: Any?) {
        // Special case
        guard expected != nil || dates.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(dates) and \(String(describing: expected)) do not match.")
            return
        }

        XCTAssertEqual(dates.count, expectedT.count)
        guard dates.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let date = dates[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key")
                continue
            }

            XCTAssertEqual(date.label, key != "nil" ? key : nil)
            assert(dateComponents: date.value, isEqual: expected[key])
        }
    }

    func assert(socialProfiles: [CNLabeledValue<CNSocialProfile>], isEqual expected: Any?) {
        // Special case
        guard expected != nil || socialProfiles.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(socialProfiles) and \(String(describing: expected)) do not match.")
            return
        }

        XCTAssertEqual(socialProfiles.count, expectedT.count)
        guard socialProfiles.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let socialProfile = socialProfiles[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key")
                continue
            }

            XCTAssertEqual(socialProfile.label, key != "nil" ? key : nil)
            assert(socialProfile: socialProfile.value, isEqual: expected[key])
        }
    }

    func assert(socialProfile: CNSocialProfile, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTFail("`socialProfile` cannot be empty.")
        case let expectedT as [String: Any]:
            let socialProfileT = try? CNSocialProfile.parse(from: expectedT)
            XCTAssertEqual(socialProfile, socialProfileT, "Value \(socialProfile) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(socialProfile) and \(String(describing: expected)) do not match.")
        }
    }

    func assert(phoneNumbers: [CNLabeledValue<CNPhoneNumber>], isEqual expected: Any?) {
        // Special case
        guard expected != nil || phoneNumbers.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(phoneNumbers) and \(String(describing: expected)) do not match.")
            return
        }

        XCTAssertEqual(phoneNumbers.count, expectedT.count)
        guard phoneNumbers.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let phoneNumber = phoneNumbers[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key")
                continue
            }

            let label = Either<PhoneNumberLabels>(string: key).stringValue
            XCTAssertEqual(phoneNumber.label, label != "nil" ? label : nil)
            assert(phoneNumber: phoneNumber.value, isEqual: expected[key])
        }
    }

    func assert(phoneNumber: CNPhoneNumber, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTFail("`phoneNumber` cannot be empty.")
        case let expectedT as [String: Any]:
            let phoneNumberT = try? CNPhoneNumber.parse(from: expectedT)
            XCTAssertEqual(phoneNumber, phoneNumberT, "Value \(phoneNumber) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(phoneNumber) and \(String(describing: expected)) do not match.")
        }
    }

    func assert(strings: [CNLabeledValue<NSString>], isEqual expected: Any?) {
        // Special case
        guard expected != nil || strings.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: NSString]] else {
            XCTFail("Types \(strings) and \(String(describing: expected)) do not match.")
            return
        }

        XCTAssertEqual(strings.count, expectedT.count)
        guard strings.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let string = strings[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key")
                continue
            }

            XCTAssertEqual(string.label, key != "nil" ? key : nil)
            XCTAssertEqual(string.value, expected[key])
        }
    }

    func assert(postalAddresses: [CNLabeledValue<CNPostalAddress>], isEqual expected: Any?) {
        // Special case
        guard expected != nil || postalAddresses.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(postalAddresses) and \(String(describing: expected)) do not match.")
            return
        }

        XCTAssertEqual(postalAddresses.count, expectedT.count)
        guard postalAddresses.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let postalAddress = postalAddresses[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key")
                continue
            }

            XCTAssertEqual(postalAddress.label, key != "nil" ? key : nil)
            assert(postalAddress: postalAddress.value, isEqual: expected[key])
        }
    }

    func assert(postalAddress: CNPostalAddress, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTFail("`postalAddress` cannot be empty.")
        case let expectedT as [String: Any]:
            let postalAddressT = try? CNMutablePostalAddress.parse(from: expectedT)
            XCTAssertEqual(postalAddress, postalAddressT, "Value \(postalAddress) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(postalAddress) and \(String(describing: expected)) do not match.")
        }
    }

    func assert(imageData: Data?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertNil(imageData, "Argument is \(String(describing: imageData)) while expected is .none.")
        case let expectedT as String:
            guard let resource = LaunchEnvironmentResource.resource(from: expectedT),
                let data = resource.bundle.data(with: resource.name) else {
                XCTFail("Cannot find resource \(expectedT)")
                return
            }
            XCTAssertEqual(imageData, data, "Value \(String(describing: imageData)) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(String(describing: imageData)) and \(String(describing: expected)) do not match.")
        }
    }

    func assert(contactRelations: [CNLabeledValue<CNContactRelation>], isEqual expected: Any?) {
        // Special case
        guard expected != nil || contactRelations.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(contactRelations) and \(String(describing: expected)) do not match.")
            return
        }

        XCTAssertEqual(contactRelations.count, expectedT.count)
        guard contactRelations.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let contactRelation = contactRelations[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key")
                continue
            }

            let label = Either<RelatedContactsLabels>(string: key).stringValue
            XCTAssertEqual(contactRelation.label, label != "nil" ? label : nil)
            assert(contactRelation: contactRelation.value, isEqual: expected[key])
        }
    }

    func assert(contactRelation: CNContactRelation, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTFail("`contactRelation` cannot be empty.")
        case let expectedT as [String: Any]:
            let contactRelationT = try? CNContactRelation.parse(from: expectedT)
            XCTAssertEqual(contactRelation, contactRelationT, "Value \(contactRelation) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(contactRelation) and \(String(describing: expected)) do not match.")
        }
    }

    func assert(instantMessageAddresses: [CNLabeledValue<CNInstantMessageAddress>], isEqual expected: Any?) {
        // Special case
        guard expected != nil || instantMessageAddresses.count != 0 else {
            return
        }

        guard let expectedT = expected as? [[String: Any]] else {
            XCTFail("Types \(instantMessageAddresses) and \(String(describing: expected)) do not match.")
            return
        }

        XCTAssertEqual(instantMessageAddresses.count, expectedT.count)
        guard instantMessageAddresses.count == expectedT.count else {
            return
        }

        for i in 0..<expectedT.count {
            let instantMessageAddress = instantMessageAddresses[i]
            let expected = expectedT[i]
            guard let key = expected.keys.first else {
                XCTFail("Missing key")
                continue
            }

            XCTAssertEqual(instantMessageAddress.label, key != "nil" ? key : nil)
            assert(instantMessageAddress: instantMessageAddress.value, isEqual: expected[key])
        }
    }

    func assert(instantMessageAddress: CNInstantMessageAddress, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTFail("`contactRelation` cannot be empty.")
        case let expectedT as [String: Any]:
            let instantMessageAddressT = try? CNInstantMessageAddress.parse(from: expectedT)
            XCTAssertEqual(instantMessageAddress, instantMessageAddressT, "Value \(instantMessageAddress) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(instantMessageAddress) and \(String(describing: expected)) do not match.")
        }
    }
}
