//
//  Message.swift
//  Chat
//
//  Created by Alisa Mylnikova on 20.04.2022.
//

import SwiftUI

public struct Message: MessageProtocol, HasReply, Identifiable, Hashable, Sendable {
    
    public enum Status: Codable, Equatable, Hashable, Sendable {
        case sending
        case sent
        case read
        case error(DraftMessage)
        
        public func hash(into hasher: inout Hasher) {
            switch self {
                case .sending:
                    return hasher.combine("SENDING")
                case .sent:
                    return hasher.combine("SENT")
                case .read:
                    return hasher.combine("READ")
                case .error:
                    return hasher.combine("ERROR")
            }
        }
        
        public static func == (lhs: Message.Status, rhs: Message.Status) -> Bool {
            switch (lhs, rhs) {
                case (.sending, .sending):
                    return true
                case (.sent, .sent):
                    return true
                case (.read, .read):
                    return true
                case ( .error(_), .error(_)):
                    return true
                default:
                    return false
            }
        }
    }
    
    public var id: String
    public var user: User
    public var status: Status?
    public var createdAt: Date
    
    public var text: String
    public var attachments: [Attachment]
    public var reactions: [Reaction]
    public var giphyMediaId: String?
    public var recording: Recording?
    public var replyMessage: ReplyMessage?
    
    public var triggerRedraw: UUID?
    
    public init(
        id: String,
        user: User,
        status: Status? = nil,
        createdAt: Date = Date(),
        text: String = "",
        attachments: [Attachment] = [],
        giphyMediaId: String? = nil,
        reactions: [Reaction] = [],
        recording: Recording? = nil,
        replyMessage: ReplyMessage? = nil,
        triggerRedraw: UUID? = nil,
    ) {
        
        self.id = id
        self.user = user
        self.status = status
        self.createdAt = createdAt
        self.text = text
        self.attachments = attachments
        self.giphyMediaId = giphyMediaId
        self.reactions = reactions
        self.recording = recording
        self.replyMessage = replyMessage
        self.triggerRedraw = triggerRedraw
    }
    
    public static func makeMessage(
        id: String,
        user: User,
        status: Status? = nil,
        draft: DraftMessage
    ) async -> Message {
        let attachments = await draft.medias.asyncCompactMap { media -> Attachment? in
            guard let thumbnailURL = await media.getThumbnailURL() else {
                return nil
            }
            
            switch media.type {
                case .image:
                    return Attachment(id: UUID().uuidString, url: thumbnailURL, type: .image)
                case .video:
                    guard let fullURL = await media.getURL() else {
                        return nil
                    }
                    return Attachment(id: UUID().uuidString, thumbnail: thumbnailURL, full: fullURL, type: .video)
            }
        }
        
        let giphyMediaId = draft.giphyMedia?.id
        
        return Message(
            id: id,
            user: user,
            status: status,
            createdAt: draft.createdAt,
            text: draft.text,
            attachments: attachments,
            giphyMediaId: giphyMediaId,
            recording: draft.recording,
            replyMessage: draft.replyMessage,
            triggerRedraw: draft.triggerRedraw,
        )
    }
}
