//
//  Date.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 06/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

extension Date {

    static func from(representation string: String) -> Date? {
        return DateFormatter.defaultJsonDateFormatter.date(from: string)
    }
}

extension DateFormatter {

    static let defaultJsonDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd k:mm:ss"
        return dateFormatter
    }()
}
