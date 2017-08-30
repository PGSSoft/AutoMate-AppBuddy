//
//  EventKitParsers.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 17/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation
import EventKit
import AutoMate_AppBuddy

class MockEventsParser: EventParser {

    var eventStore: EKEventStore! = EKEventStore()
    lazy var calendar: EKCalendar? = {
        return self.eventStore.defaultCalendarForNewEvents
    }()
    let span = EKSpan.futureEvents
    var dataRecived: [Any] = []

    func parse(_ data: [String: Any]) throws -> EKEvent {
        dataRecived.append(data)
        return EKEvent(eventStore: eventStore)
    }

    public func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
}

class MockRemindersParser: ReminderParser {

    var eventStore: EKEventStore! = EKEventStore()
    lazy var calendar: EKCalendar? = {
        return self.eventStore.defaultCalendarForNewEvents
    }()
    let span = EKSpan.futureEvents
    var dataRecived: [Any] = []

    func parse(_ data: [String: Any]) throws -> EKReminder {
        dataRecived.append(data)
        return EKReminder(eventStore: eventStore)
    }

    public func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        completion(true, nil)
    }
}
