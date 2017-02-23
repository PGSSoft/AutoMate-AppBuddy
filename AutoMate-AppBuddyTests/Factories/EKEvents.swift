//
//  EKEvents.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 06/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit
import AutoMate_AppBuddy

enum EventFactory {

    static let eventDictWithMinimalInformations: [String: Any] = {
        return [
            "title": "Minimal Event Title",
            "startDate": "2017-01-22 13:45:00",
            "endDate": "2017-01-22 14:30:00"
        ]
    }()

    static let eventDictWithRandomInformations: [String: Any] = {
        return [
            "title": "Random Event Title",
            "startDate": "2017-01-22 13:45:00",
            "endDate": "2017-01-22 14:30:00",
            "notes": "Everybody are welcome",
            "recurrenceRules": [
                [
                    "frequency": 2,
                    "interval": 3,
                    "daysOfTheMonth": [15, 16, 20]
                ]
            ]
        ]
    }()

    static let eventDictWithAllInformations: [String: Any] = {
        return [
            "eventIdentifier": "AutoMate-retrospective",
            "title": "All Info Event Title",
            "location": "Conference room",
            "startDate": "2017-01-22 13:45:00",
            "endDate": "2017-01-22 14:30:00",
            "notes": "Everybody are welcome",
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
                    "daysOfTheWeek": [5],
                    "occurrenceCount": 17,
                    "setPositions": [-2, 13, 57, -200]
                ]
            ]
        ]
    }()
}
