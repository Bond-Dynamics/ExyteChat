//
//  Created by Alex.M on 17.06.2022.
//

import Foundation

public enum UserType: Int, Codable, Sendable {
    case current = 0, other, system
}

public struct User: Codable, Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let avatarURL: URL?
    public let type: UserType
    
    public init() {
        self.id = UUID()
        self.name = ""
        self.avatarURL = nil
        self.type = .system
    }
    
    public init(id: UUID, name: String, avatarURL: URL?, isCurrentUser: Bool) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
        self.type = isCurrentUser ? .current : .other
    }
    
    public init(id: UUID, name: String, avatarURL: URL?, type: UserType) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
        self.type = type
    }
}

extension User {
    /// Determines if this user is the current user by comparing against the ChatViewModel's current user
    @MainActor
    public var isCurrentUser: Bool {
        // First try to use the global current user context if available
        if let currentUserId = ChatUserContext.shared.currentUserId {
            return self.id == currentUserId
        }
        // Fallback to legacy UserType-based approach
        return type == .current
    }
}

/// Global context for tracking the current user across the chat system
@MainActor
public class ChatUserContext: ObservableObject {
    public static let shared = ChatUserContext()
    
    private(set) var currentUserId: UUID?
    
    private init() {}
    
    public func setCurrentUser(_ user: User) {
        currentUserId = user.id
    }
    
    public func clearCurrentUser() {
        currentUserId = nil
    }
}
