//
//  EKEvents.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 06/02/2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import Foundation

enum EventFactory {

    static let eventWithMinimalInformations: [String: Any] = {
        return [
            "title": "Minimal Event Title",
            "startDate": "2017-01-22 13:45:00",
            "endDate": "2017-01-22 14:30:00",
        ]
    }()

    static let eventWithRandomInformations: [String: Any] = {
        return [
            "title": "Random Event Title",
            "startDate": "2017-01-22 13:45:00",
            "endDate": "2017-01-22 14:30:00",
            "notes": "Everybody are welcome",
            "organizer": [
                "name": "Johny Ive",
                "role": 1
            ],
            "recurrenceRules": [
                [
                    "frequency": 2,
                    "interval": 3,
                    "daysOfTheMonth": [15, 16, 20],
                ]
            ]
        ]
    }()

    static let eventWithAllInformations: [String: Any] = {
        return [
            "eventIdentifier": "AutoMate-retrospective",
            "title": "All Info Event Title",
            "location": "Conference room",
            "startDate": "2017-01-22 13:45:00",
            "endDate": "2017-01-22 14:30:00",
            "notes": "Everybody are welcome",
            "organizer": [
                "name": "Johny Ive",
                "status": 0,
                "type": 3,
                "role": 1,
                "contactPredicate": "firstName == Johny AND lastName == Ive",
                "isCurrentUser": false
            ],
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
            ],
            "attendees": [
                [
                    "name": "John Apple",
                    "status": 0,
                    "type": 3,
                    "role": 1,
                    "contactPredicate": "firstName == Johny AND lastName == Ive",
                    "isCurrentUser": false
                ],
                [
                    "name": "Taylor Swift",
                    "status": 1,
                    "type": 0,
                    "role": 2,
                    "contactPredicate": "firstName == Taylor AND lastName == Swift",
                    "isCurrentUser": true
                ],
                [
                    "name": "Tim Cook",
                    "status": 3,
                    "type": 4,
                    "role": 3,
                    "contactPredicate": "firstName == Tim AND lastName == Cook",
                    "isCurrentUser": false
                ]
            ]
        ]
    }()
}
