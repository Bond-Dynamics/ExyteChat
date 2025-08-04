//
//  ReplyMessage.swift
//  Chat
//
//  Created by Michael Shaw on 8/4/25.
//

import Foundation

public struct ReplyMessage: MessageProtocol, Codable, Identifiable, Hashable, Sendable {
    public static func == (lhs: ReplyMessage, rhs: ReplyMessage) -> Bool {
        lhs.id == rhs.id &&
        lhs.user == rhs.user &&
        lhs.createdAt == rhs.createdAt &&
        lhs.text == rhs.text &&
        lhs.attachments == rhs.attachments &&
        lhs.recording == rhs.recording
    }

    public var id: UUID
    public var user: User
    public var createdAt: Date
    public var text: String
    public var attachments: [Attachment]
    public var reactions: [Reaction]
    public var giphyMediaId: String?
    public var recording: Recording?
    public var triggerRedraw: UUID?
    
    public func user(current profileID: UUID) -> User {
        user
    }

    public init(
        id: UUID,
        user: User,
        createdAt: Date,
        text: String = "",
        attachments: [Attachment] = [],
        reactions: [Reaction] = [],
        giphyMediaId: String?,
        recording: Recording? = nil,
        triggerRedraw: UUID?,
    ) {
        self.id = id
        self.user = user
        self.createdAt = createdAt
        self.text = text
        self.attachments = attachments
        self.reactions = reactions
        self.giphyMediaId = giphyMediaId
        self.recording = recording
        self.triggerRedraw = triggerRedraw
    }

    func toMessage() -> Message {
        Message(
            id: id,
            user: user,
            createdAt: createdAt,
            text: text,
            attachments: attachments,
            giphyMediaId: giphyMediaId,
            reactions: reactions,
            recording: recording,
            triggerRedraw: triggerRedraw
        )
    }
}
