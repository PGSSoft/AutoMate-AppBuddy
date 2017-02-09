//
//  EventKitParser.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 17/01/2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import EventKit

// MARK: - Event Parser
public protocol EventParser: Parser {

	// MARK: Typealiases
	typealias T = EKEvent

	// MARK: Properties
	/// `EKEventStore` in which parsed `EKEvent`s will be created and saved.
	var eventStore: EKEventStore { get }
	/// `EKEvents` calendar for new events.
	var calendar: EKCalendar { get }
}

public extension EventParser {

	/// Will access all
	///
	/// - Parameters:
	///   - resources: Array of resources discribing path to events data.
	///   - span: _Values for controlling what occurrences to affect in a recurring event._ `.futureEvents` by default.
	/// - Throws: `ParserError` if data has unexpected format or standard `Error` for saving and commiting in EventKit.
	public func parseAndSave(resources: [LaunchEnviromentResource], with span: EKSpan = .futureEvents) throws {
		try parsed(resources: resources).forEach { try eventStore.save($0, span: span) }
		try eventStore.commit()
	}
}

// MARK: - Event Dictionary Parser
public struct EventDictionaryParser: EventParser {

	// MARK: Properties
	public var eventStore: EKEventStore
	public var calendar: EKCalendar

	// MARK: Initialization
	public init(with eventStore: EKEventStore, calendar: EKCalendar? = nil) {
		self.eventStore = eventStore
		self.calendar = calendar ?? eventStore.defaultCalendarForNewEvents
	}

	// MARK: Public methods
	public func parse(_ data: Any) throws -> EKEvent {
		guard let jsonDict = data as? [String: Any] else {
			throw ParserError(message: "Expected dictionary, given \(data)")
		}

		let creationDate = try jsonDict.fetchOptional("creationDate") { Date.from(representation: $0) }
		let startDate = try jsonDict.fetch("startDate") { Date.from(representation: $0) }
		let endDate = try jsonDict.fetch("endDate") { Date.from(representation: $0) }
		let recurrenceRules = try jsonDict.fetchOptionalArray("recurrenceRules") { try recurrenceRule(from: $0) }

		let event = EKEvent(eventStore: eventStore)
		event.calendar = calendar
		event.title = try jsonDict.fetch("title")
		event.location = try jsonDict.fetchOptional("location")
		event.notes = try jsonDict.fetchOptional("notes")
		event.setValue(creationDate, forKey: "creationDate")
		event.setValuesForKeys([
			                           "startDate": startDate,
			                           "endDate": endDate
		                           ])
		recurrenceRules?.forEach { event.addRecurrenceRule($0) }

		return event
	}

	// MARK: Private methods
	private func recurrenceRule(from json: [String: Any]) throws -> EKRecurrenceRule? {
		guard let frequency = EKRecurrenceFrequency(rawValue: try json.fetch("frequency")) else {
			return nil
		}

		return EKRecurrenceRule(recurrenceWith: frequency,
		                            interval: try json.fetch("interval"),
		                            daysOfTheWeek: try json.fetchOptionalArray("daysOfTheWeek") { try dayOfTheWeek(from: $0) },
		                            daysOfTheMonth: try json.fetchOptional("daysOfTheMonth"),
		                            monthsOfTheYear: try json.fetchOptional("monthsOfTheYear"),
		                            weeksOfTheYear: try json.fetchOptional("weeksOfTheYear"),
		                            daysOfTheYear: try json.fetchOptional("daysOfTheYear"),
		                            setPositions: try json.fetchOptional("setPositions"),
		                            end: try recurrenceEnd(with: json))
	}

	private func recurrenceEnd(with json: [String: Any]) throws -> EKRecurrenceEnd? {

		if let endDate = try json.fetchOptional("endDate") { Date.from(representation: $0) } {
			return EKRecurrenceEnd(end: endDate)
		} else if let occurrenceCount = try json.fetchOptional("occurrenceCount") as Int? {
			return EKRecurrenceEnd(occurrenceCount: occurrenceCount)
		}

		return nil
	}

	private func dayOfTheWeek(from dayNo: Int) throws -> EKRecurrenceDayOfWeek {
		guard let weekday = EKWeekday(rawValue: dayNo) else {
			throw ParserError(message: "Day \(dayNo) out of range of week.")
		}
		return EKRecurrenceDayOfWeek(weekday)
	}
}
