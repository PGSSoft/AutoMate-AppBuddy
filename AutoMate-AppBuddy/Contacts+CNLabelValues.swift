//
//  Contacts+Helpers.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 22.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation
import Contacts

// MARK: - SocialProfileService
enum SocialProfileService: String {
    case facebook
    case flicker
    case linkedIn
    case mySpace
    case sinaWeibo
    case tencentWeibo
    case twitter
    case yelp
    case gameCenter

    var rawValue: String {
        switch self {
        case .facebook: return CNSocialProfileServiceFacebook
        case .flicker: return CNSocialProfileServiceFlickr
        case .linkedIn: return CNSocialProfileServiceLinkedIn
        case .mySpace: return CNSocialProfileServiceMySpace
        case .sinaWeibo: return CNSocialProfileServiceSinaWeibo
        case .tencentWeibo: return CNSocialProfileServiceTencentWeibo
        case .twitter: return CNSocialProfileServiceTwitter
        case .yelp: return CNSocialProfileServiceYelp
        case .gameCenter: return CNSocialProfileServiceGameCenter
        }
    }
}

// MARK: - PhoneNumberLabels
enum PhoneNumberLabels: String {
    case iPhone
    case mobile
    case main
    case homeFax
    case workFax
    case otherFax
    case pager

    var rawValue: String {
        switch self {
        case .iPhone: return CNLabelPhoneNumberiPhone
        case .mobile: return CNLabelPhoneNumberMobile
        case .main: return CNLabelPhoneNumberMain
        case .homeFax: return CNLabelPhoneNumberHomeFax
        case .workFax: return CNLabelPhoneNumberWorkFax
        case .otherFax: return CNLabelPhoneNumberOtherFax
        case .pager: return CNLabelPhoneNumberPager
        }
    }
}

// MARK: - RelatedContactsLabels
enum RelatedContactsLabels: String {
    case father
    case mother
    case parent
    case brother
    case sister
    case child
    case friend
    case spouse
    case partner
    case assistant
    case manager

    var rawValue: String {
        switch self {
        case .father: return CNLabelContactRelationFather
        case .mother: return CNLabelContactRelationMother
        case .parent: return CNLabelContactRelationParent
        case .brother: return CNLabelContactRelationBrother
        case .sister: return CNLabelContactRelationSister
        case .child: return CNLabelContactRelationChild
        case .friend: return CNLabelContactRelationFriend
        case .spouse: return CNLabelContactRelationSpouse
        case .partner: return CNLabelContactRelationPartner
        case .assistant: return CNLabelContactRelationAssistant
        case .manager: return CNLabelContactRelationManager
        }
    }
}

// MARK: - InstantMessageServices
enum InstantMessageServices: String {
    case aim
    case facebook
    case gaduGadu
    case googleTalk
    case icq
    case jabber
    case msn
    // swiftlint:disable:next identifier_name
    case qq
    case skype
    case yahoo

    var rawValue: String {
        switch self {
        case .aim: return CNInstantMessageServiceAIM
        case .facebook: return CNInstantMessageServiceFacebook
        case .gaduGadu: return CNInstantMessageServiceGaduGadu
        case .googleTalk: return CNInstantMessageServiceGoogleTalk
        case .icq: return CNInstantMessageServiceICQ
        case .jabber: return CNInstantMessageServiceJabber
        case .msn: return CNInstantMessageServiceMSN
        case .qq: return CNInstantMessageServiceQQ
        case .skype: return CNInstantMessageServiceSkype
        case .yahoo: return CNInstantMessageServiceYahoo
        }
    }
}
