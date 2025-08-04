//
//  MessageProtocol.swift
//  Chat
//
//  Created by Michael Shaw on 8/4/25.
//

import Foundation

public protocol MessageProtocol: Identifiable {
    var id: String { get set }
    var user: User { get set }
    var text: String { get set }
    var createdAt: Date { get set }
    var attachments: [Attachment] { get set }
    var reactions: [Reaction] { get set }
    var giphyMediaId: String? { get set }
    var recording: Recording? { get set }
    var triggerRedraw: UUID? { get set }
}

public protocol HasReply {
    var replyMessage: ReplyMessage? { get set }
}

public protocol HasStatus {
    var status: Message.Status? { get set }
}
