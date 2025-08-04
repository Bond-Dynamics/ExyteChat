//
//  Message+Ext.swift
//  Chat
//
//  Created by Michael Shaw on 8/4/25.
//

import Foundation

extension Message: Equatable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id &&
        lhs.user == rhs.user &&
        lhs.status == rhs.status &&
        lhs.createdAt == rhs.createdAt &&
        lhs.text == rhs.text &&
        lhs.giphyMediaId == rhs.giphyMediaId &&
        lhs.attachments == rhs.attachments &&
        lhs.reactions == rhs.reactions &&
        lhs.recording == rhs.recording &&
        lhs.replyMessage == rhs.replyMessage &&
        lhs.triggerRedraw == rhs.triggerRedraw
    }
}

public extension Message {
    func toReplyMessage() -> ReplyMessage {
        ReplyMessage(id: id, user: user ?? .init(), createdAt: createdAt, text: text, attachments: attachments, giphyMediaId: giphyMediaId, recording: recording, triggerRedraw: triggerRedraw)
    }
}
