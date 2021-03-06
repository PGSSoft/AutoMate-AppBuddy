//
//  Contacts.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 16.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

enum ContactsFactory {

    static let contactWithMinimalInformations: [String: Any] = {
        return [
            "contactType": "person"
        ]
    }()

    static let contactWithAllInformations: [String: Any] = {
        return [
            "contactType": "person",
            "dates": [
                ["date1": ["year": 2017, "month": 2, "day": 17]],
                ["date2": ["year": 2005, "month": 6, "day": 4]],
                ["nil": ["year": 2000, "month": 6, "day": 4]]
            ],
            "nonGregorianBirthday": ["year": 2016, "month": 5, "day": 19],
            "birthday": ["year": 2016, "month": 5, "day": 19],
            "namePrefix": "Name Prefix",
            "givenName": "Given Name",
            "middleName": "Middle Name",
            "familyName": "Family Name",
            "previousFamilyName": "Previous Family Name",
            "nameSuffix": "Name Suffix",
            "nickname": "Nickname",
            "phoneticGivenName": "Phonetic Given Name",
            "phoneticMiddleName": "Phonetic Middle Name",
            "phoneticFamilyName": "Phonetic Family Name",
            "organizationName": "Organization Name",
            "phoneticOrganizationName": "Phonetic Organization Name",
            "departmentName": "Department Name",
            "jobTitle": "Job Title",
            "socialProfiles": [
                ["social1": ["urlString": "profile url", "username": "username", "userIdentifier": "87654321", "service": "facebook"]],
                ["social1": ["urlString": "profile url", "username": "username", "userIdentifier": "876345", "service": "twitter"]],
                ["nil": ["urlString": "profile url", "username": "username", "userIdentifier": "1234", "service": "Google"]]
            ],
            "phoneNumbers": [
                ["work": ["stringValue": "0 1234567890"]],
                ["mobile": ["stringValue": "0 1234567890"]],
                ["nil": ["stringValue": "0 1234567890"]]
            ],
            "emailAddresses": [
                ["email1": "email1@example.com"],
                ["email2": "email2@example.com"],
                ["nil": "email3@example.com"]
            ],
            "urlAddresses": [
                ["url1": "https://url1.example.com"],
                ["url2": "https://url2.example.com"],
                ["nil": "https://url3.example.com"]
            ],
            "postalAddresses": [
                ["home": ["street": "street", "city": "city", "state": "state", "postalCode": "postalCode", "country": "country", "isoCountryCode": "PL"]],
                ["nil": ["street": "street", "city": "city", "state": "state", "postalCode": "postalCode", "country": "country", "isoCountryCode": "PL"]]
            ],
            "note": "Some Note",
            "imageData": "com.pgs-soft.AutoMate-AppBuddyTests:AutoMate.png",
            "contactRelations": [
                ["father": ["name": "John"]],
                ["other": ["name": "John"]],
                ["nil": ["name": "John"]]
            ],
            "instantMessageAddresses": [
                ["skype": ["username": "John@skype", "service": "skype"]],
                ["nil": ["username": "John@skype", "service": "Slack"]]
            ]
        ]
    }()
}
