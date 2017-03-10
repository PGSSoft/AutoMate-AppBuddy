//
//  EventKitInterface.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 01/03/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import EventKit

/// Define metohods required to interact with `EventKit` framework.
///
/// - seealso: `EventKitInterface`
public protocol EventKitInterfaceProtocol {
    typealias CompletionBlock = (Bool, Error?) -> Void

    /// Adds all calendar items to the `EKEventStore`.
    ///
    /// - Parameters:
    ///   - calendarItems: List of calendar items, a subclasses of `EKCalendarItem`.
    ///   - type: Type of entity to add.
    ///   - completion: Completion closure called after items were saved to the store.
    func addAll(_ calendarItems: [EKCalendarItem], forType type: EKEntityType, completion: @escaping CompletionBlock)

    ///  Remove all calendar items from the `EKEventStore`.
    ///
    /// - Parameters:
    ///   - type: Type of entity to remove.
    ///   - completion: Completion closure called after items were removed from the store.
    func removeAll(ofType type: EKEntityType, completion: @escaping CompletionBlock)

    /// Request access to the `EventKit` framework for given item type.
    ///
    /// - Parameters:
    ///   - type: Type of entity to request access.
    ///   - completion: Completion closure.
    func requestAccess(forType type: EKEntityType, completion: @escaping CompletionBlock)
}

/// Provides a basic mechanism for interacting with the `EventKit` framework.
///
/// Conforms to the `EventKitInterfaceProtocol` protocol.
public class EventKitInterface: EventKitInterfaceProtocol {

    // MARK: Properties
    private let eventStore: EKEventStore
    private let eventSpan: EKSpan
    private let eventStartDate: Date
    private let eventEndDate: Date

    // MARK: Initialization
    /// Initialize object with the `EKEventStore` and with a start and an end date.
    ///
    /// If the event store is not provided a new one is created.
    /// The start and the end date are used to filter events and reminders to remove.
    ///
    /// - Parameters:
    ///   - eventStore: An event store used to communicate.
    ///   - eventSpan: Indicates whether modifications should apply to a single event or all future events of a recurring event.
    ///   - eventStartDate: A start date for items filtering. By default a year ago.
    ///   - eventEndDate: An end date for items filtering. By default next year.
    public init(eventStore: EKEventStore = EKEventStore(), eventSpan: EKSpan = .futureEvents, eventStartDate: Date = Date.yearAgo, eventEndDate: Date = Date.nextYear) {
        self.eventStore = eventStore
        self.eventSpan = eventSpan
        self.eventStartDate = eventStartDate
        self.eventEndDate = eventEndDate
    }

    // MARK: Methods
    /// Adds all calendar items to the `EKEventStore`.
    ///
    /// - Parameters:
    ///   - calendarItems: List of calendar items, a subclasses of `EKCalendarItem`.
    ///   - type: Type of entity to add.
    ///   - completion: Completion closure called after items were saved to the store.
    public func addAll(_ calendarItems: [EKCalendarItem], forType type: EKEntityType, completion: @escaping EventKitInterfaceProtocol.CompletionBlock = { _, _ in }) {
        do {
            try calendarItems.forEach { try save(item: $0, ofType: type) }
            try eventStore.commit()
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }

    ///  Remove all calendar items from the `EKEventStore`.
    ///
    /// - Parameters:
    ///   - type: Type of entity to remove.
    ///   - completion: Completion closure called after items were removed from the store.
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

    /// Request access to the `EventKit` framework for given item type.
    ///
    /// - Parameters:
    ///   - type: Type of entity to request access.
    ///   - completion: Completion closure.
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
