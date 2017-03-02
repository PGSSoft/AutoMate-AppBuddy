//
//  EventKitInterface.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 01/03/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit

public protocol EventKitInterfaceProtocol {
    typealias CompletionBlock = (Bool, Error?) -> Void
    func addAll(_ calendarItems: [EKCalendarItem], forType type: EKEntityType, completion: @escaping CompletionBlock)
    func removeAll(ofType type: EKEntityType, completion: @escaping CompletionBlock)
    func requestAccess(forType type: EKEntityType, completion: @escaping CompletionBlock)
}

public class EventKitInterface: EventKitInterfaceProtocol {

    // MARK: Properties
    private let eventStore: EKEventStore
    private let eventSpan: EKSpan
    private let eventStartDate: Date
    private let eventEndDate: Date

    // MARK: Initialization
    public init(eventStore: EKEventStore = EKEventStore(), eventSpan: EKSpan = .futureEvents, eventStartDate: Date = Date.yearAgo, eventEndDate: Date = Date.nextYear) {
        self.eventStore = eventStore
        self.eventSpan = eventSpan
        self.eventStartDate = eventStartDate
        self.eventEndDate = eventEndDate
    }

    // MARK: Methods
    public func addAll(_ calendarItems: [EKCalendarItem], forType type: EKEntityType, completion: @escaping EventKitInterfaceProtocol.CompletionBlock = { _, _ in }) {
        do {
            try calendarItems.forEach { try save(item: $0, ofType: type) }
            try eventStore.commit()
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }

    public func removeAll(ofType type: EKEntityType, completion: @escaping EventKitInterfaceProtocol.CompletionBlock = { _, _ in }) {
        fetchAll(ofType: type) { [weak self] (items) in
            do {
                try items?.forEach { try self?.remove(item: $0, ofType: type) }
                try self?.eventStore.commit()
                completion(true, nil)
            } catch let error {
                completion(false, error)
            }
        }
    }

    public func requestAccess(forType type: EKEntityType, completion: @escaping EventKitInterfaceProtocol.CompletionBlock) {
        eventStore.requestAccess(to: type, completion: completion)
    }

    private func save(item: EKCalendarItem, ofType type: EKEntityType) throws {
        switch (type, item) {
        case let (.event, event as EKEvent): try eventStore.save(event, span: eventSpan, commit: false)
        case let (.reminder, reminder as EKReminder): try eventStore.save(reminder, commit: false)
        default: throw ParserError(message: "")
        }
    }

    private func remove(item: EKCalendarItem, ofType type: EKEntityType) throws {
        switch (type, item) {
        case let (.event, event as EKEvent): try eventStore.remove(event, span: eventSpan, commit: false)
        case let (.reminder, reminder as EKReminder): try eventStore.remove(reminder, commit: false)
        default: throw ParserError(message: "")
        }
    }

    private func fetchAll(ofType type: EKEntityType, completion: @escaping ([EKCalendarItem]?) -> Void) {
        switch type {
        case .event:
            var events = [EKEvent]()
            eventStore.enumerateEvents(matching: eventStore.predicateForEvents(withStart: eventStartDate,
                                                                               end: eventEndDate,
                                                                               calendars: nil)) { events.append($0.0) }
            completion(events)
        case .reminder:
            eventStore.fetchReminders(matching: eventStore.predicateForReminders(in: nil), completion: { completion($0) })
        }
    }
}
