//
//  EKParticipant.swift
//  AutoMate App Companion
//
//  Created by Joanna Bednarz on 06/02/2017.
//  Copyright © 2017 Joanna Bednarz. All rights reserved.
//

import EventKit

internal extension EKParticipant {

    internal class func from(json: [String: Any]) throws -> EKParticipant {

        let name: String? = try json.fetchOptional("name")
        let url = try json.fetchOptional("url") ?? ""
        let status = try json.fetch("status") { EKParticipantStatus(rawValue: $0) ?? .accepted }
        let role = try json.fetch("role") { EKParticipantRole(rawValue: $0) ?? .optional }
        let type = try json.fetch("type") { EKParticipantType(rawValue: $0) ?? .person }
        let predicateString: String? = try json.fetchOptional("contactPredicate")
        let contactPredicate = predicateString.flatMap { NSPredicate(format: $0) } ?? NSPredicate(value: false)
        let isCurrentUser = try json.fetchOptional("isCurrentUser") ?? true

        let participant = EKParticipant()
        participant.setValue(name, forKey: "name")
        participant.setValue(url, forKey: "url")
        participant.setValue(status, forKey: "participantStatus")
        participant.setValue(role, forKey: "participantRole")
        participant.setValue(type, forKey: "participantType")
        participant.setValue(contactPredicate, forKey: "contactPredicate")
        participant.setValue(isCurrentUser, forKey: "isCurrentUser")

        return participant
    }
}
