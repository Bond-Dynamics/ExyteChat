//
//  MessageProtocol+Ext.swift
//  Chat
//
//  Created by Michael Shaw on 8/4/25.
//

import Foundation

extension MessageProtocol {
    func toReplyMessage() -> ReplyMessage {
        ReplyMessage(
            id: id,
            user: user,
            createdAt: createdAt,
            text: text,
            attachments: attachments,
            giphyMediaId: giphyMediaId,
            recording: recording,
            triggerRedraw: triggerRedraw
        )
    }
    
    var time: String {
        DateFormatter.timeFormatter.string(from: createdAt ?? Date())
    }
}
