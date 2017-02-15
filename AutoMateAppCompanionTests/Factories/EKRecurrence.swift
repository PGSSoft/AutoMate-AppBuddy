//
//  EKRecurrence.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 15/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

enum EKRecurrenceFactory {

    static var dailyRecurenceRule: [String: Any] = [
        "frequency": 0,
        "interval": 3
    ]

    static var weeklyRecurenceRule: [String: Any] = [
        "frequency": 1,
        "interval": 2,
        "daysOfTheWeek": [1, 3, 5]
    ]

    static var monthlyRecurenceRule: [String: Any] = [
        "frequency": 2,
        "interval": 6,
        "daysOfTheMonth": [9, 16, 22],
        "setPositions": [2, -4, 1],
        "occurrenceCount": 17
    ]

    static var yearlyRecurenceRule: [String: Any] = [
        "frequency": 3,
        "interval": 1,
        "monthsOfTheYear": [2, 6, 9],
        "setPositions": [-1, 2, 1],
        "endDate": "2017-01-22 14:30:00"
    ]
}
