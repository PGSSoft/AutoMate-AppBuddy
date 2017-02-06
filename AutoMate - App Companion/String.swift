//
//  String.swift
//  AutoMate App Companion
//
//  Created by Bartosz Janda on 03.02.2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import Foundation

extension String {

    /// Return Bool value for given string
    ///
    /// - Returns: `true` or `false`
    public func toBool() -> Bool? {
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
