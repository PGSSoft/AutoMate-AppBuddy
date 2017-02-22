//
//  ContactsParsers.swift
//  AutoMate App Companion
//
//  Created by Bartosz Janda on 22.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation
import Contacts
import AutoMateAppCompanion

class MockContactsParser: ContactParser {

    let store = CNContactStore()
    var dataRecived: [Any] = []

    func parse(_ data: Any) throws -> CNMutableContact {
        dataRecived.append(data)
        return CNMutableContact()
    }
}
