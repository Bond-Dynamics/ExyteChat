//
//  MessageProtocol.swift
//  Chat
//
//  Created by Michael Shaw on 8/4/25.
//

import Foundation

public protocol MessageProtocol: Codable, Identifiable {
    var id: UUID { get }
    var user: User { get set }
    var text: String { get set }
    var createdAt: Date { get }
    var attachments: [Attachment] { get set }
    var reactions: [Reaction] { get set }
    var giphyMediaId: String? { get }
    var recording: Recording? { get }
    var triggerRedraw: UUID? { get }
}

public protocol HasReply: Codable {
    var replyMessage: ReplyMessage? { get }
}

public protocol HasStatus: Codable {
    var status: Message.Status? { get }
}
