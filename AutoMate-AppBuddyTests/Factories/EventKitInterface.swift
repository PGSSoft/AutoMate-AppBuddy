//
//  EventKitInterface.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 13/03/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import Foundation
import AutoMate_AppBuddy
import EventKit

class MockEventKitInterface: EventKitInterfaceProtocol {

    public var events = [EKEvent]()
    public var reminders = [EKReminder]()
    public var eventsCleaned = false
    public var remindersCleaned = false

    static func authorized(forType type: EKEntityType) -> Bool {
        return true
    }

    func addAll(_ calendarItems: [EKCalendarItem], forType type: EKEntityType, completion: @escaping EventKitInterfaceProtocol.CompletionBlock) {
        switch type {
        case .event:
            guard let items = calendarItems as? [EKEvent] else {
                completion(false, nil)
                return
            }
            events.append(contentsOf: items)
        case .reminder:
            guard let items = calendarItems as? [EKReminder] else {
                completion(false, nil)
                return
            }
            reminders.append(contentsOf: items)
        }
        completion(true, nil)
    }

    func removeAll(ofType type: EKEntityType, completion: @escaping EventKitInterfaceProtocol.CompletionBlock) {
        switch type {
        case .event:
            events.removeAll()
            eventsCleaned = true
        case .reminder:
            reminders.removeAll()
            remindersCleaned = true
        }
        completion(true, nil)
    }

    func requestAccess(forType type: EKEntityType, completion: @escaping (Bool, Error?, EKEventStore?) -> Void) {
        completion(true, nil, EKEventStore())
    }
}
