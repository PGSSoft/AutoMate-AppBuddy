//
//  EKReminders.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 14/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation

enum ReminderFactory {
    static let reminderWithAllInfo: [String: Any] = {
        return [
            "title": "All Info Event Title",
            "location": "Conference room",
            "notes": "Everybody are welcome",
            "priority": 1,
            "isCompleted": true,
            "recurrenceRules": [
                [
                    "frequency": 1,
                    "interval": 4,
                    "daysOfTheWeek": [2, 4],
                    "endDate": "2017-01-22 14:30:00",
                    "setPositions": [1, 3, -34, -129, 256]
                ],
                [
                    "frequency": 0,
                    "interval": 6,
                    "daysOfTheWeek": [
                        5
                    ],
                    "occurrenceCount": 17,
                    "setPositions": [-2, 13, 57, -200]
                ]
            ],
            "startDateComponents": [
                "timeZone": [
                    "identifier": "America/Los_Angeles"
                ],
                "year": 2017,
                "month": 10,
                "day": 24
            ],
            "dueDateComponents": [
                "timeZone": [
                    "secondsFromGMT": 3000
                ],
                "year": 2018,
                "month": 10,
                "day": 24,
                "hour": 12,
                "minute": 25,
                "second": 0
            ],
            "completionDate": "2017-01-22 14:30:00"
        ]
    }()

    static let reminderWithRandomInfo: [String: Any] = {
        return [
            "title": "Random Event Title",
            "notes": "Everybody are welcome",
            "priority": 11,
            "recurrenceRules": [
                [
                    "frequency": 2,
                    "interval": 3,
                    "daysOfTheMonth": [
                        15,
                        16,
                        20
                    ]
                ]
            ],
            "startDateComponents": [
                "timeZone": [
                    "abbreviation": "AST"
                ],
                "hour": 8,
                "minute": 45,
                "second": 30,
                "year": 2018,
                "month": 1,
                "day": 25
            ]
        ]
    }()

    static let reminderWithMinimalInfo: [String: Any] = {
        return [
            "title": "Minimal Event Title",
            "priority": 3
        ]
    }()
}
