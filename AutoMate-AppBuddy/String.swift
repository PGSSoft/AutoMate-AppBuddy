//
//  String.swift
//  AutoMate-AppBuddy
//
//  Created by Bartosz Janda on 03.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

extension String {

    /// Return Bool value for given string
    ///
    /// - Returns: `true`, `false`, or `.none`, if cannot match to Bool value
    var boolValue: Bool? {
        switch self.lowercased() {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
