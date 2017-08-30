//
//  Date.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 06/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

extension Date {

    public static let yearAgo: Date = {
        guard let date = Calendar(identifier: .gregorian).date(byAdding: .year, value: -1, to: Date()) else {
            preconditionFailure("Date could not be calculated with the given input.")
        }
        return date
    }()

    public static let nextYear: Date = {
        guard let date = Calendar(identifier: .gregorian).date(byAdding: .year, value: 1, to: Date()) else {
            preconditionFailure("Date could not be calculated with the given input.")
        }
        return date
    }()

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
