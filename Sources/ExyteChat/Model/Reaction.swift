//
//  Reaction.swift
//  Chat
//

import Foundation

public enum ReactionType: Codable, Equatable, Hashable, Sendable {
    case emoji(String)
    //case sticker(Image / Giphy / Memoji)
    //case other...
    
    var toString: String {
        switch self {
        case .emoji(let emoji):
            return emoji
        }
    }
}

public struct Reaction: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let user: User
    public let createdAt: Date
    public let type: ReactionType
    public var status: Status

    public init(id: UUID = UUID(), user: User, createdAt: Date = .now, type: ReactionType, status: Status = .sending) {
        self.id = id
        self.user = user
        self.createdAt = createdAt
        self.type = type
        self.status = status
    }
    
    var emoji: String? {
        switch self.type {
        case .emoji(let emoji): return emoji
        }
    }
}

extension Reaction {
    public enum Status: Codable, Equatable, Hashable, Sendable {
        case sending
        case sent
        case read
        case error(DraftReaction)
    }
}

public struct DraftReaction: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let messageID: UUID
    public let createdAt: Date
    public let type: ReactionType

    public init(id: UUID = UUID(), messageID: UUID, createdAt: Date = .now, type: ReactionType) {
        self.id = id
        self.messageID = messageID
        self.createdAt = createdAt
        self.type = type
    }
}

