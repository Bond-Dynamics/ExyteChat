//
//  MessageMenu+Action.swift
//  Chat
//

import SwiftUI

public protocol MessageMenuAction: Equatable, CaseIterable {
    func title() -> String
    func icon() -> Image
    
    static func menuItems(for message: any MessageProtocol) -> [Self]
}

public enum DefaultMessageMenuAction: @MainActor MessageMenuAction, Sendable {

    case copy
    case reply
    case edit(saveClosure: @Sendable (String) -> Void)

    public func title() -> String {
        switch self {
        case .copy:
            "Copy"
        case .reply:
            "Reply"
        case .edit:
            "Edit"
        }
    }

    public func icon() -> Image {
        switch self {
        case .copy:
            Image(systemName: "doc.on.doc")
        case .reply:
            Image(systemName: "arrowshape.turn.up.left")
        case .edit:
            Image(systemName: "bubble.and.pencil")
        }
    }

    nonisolated public static func == (lhs: DefaultMessageMenuAction, rhs: DefaultMessageMenuAction) -> Bool {
        switch (lhs, rhs) {
        case (.copy, .copy),
             (.reply, .reply),
             (.edit(_), .edit(_)):
            return true
        default:
            return false
        }
    }

    public static let allCases: [DefaultMessageMenuAction] = [
        .copy, .reply, .edit(saveClosure: {_ in})
    ]
    
    @MainActor
    public static func menuItems(for message: any MessageProtocol) -> [DefaultMessageMenuAction] {
        if message.user.isCurrentUser {
            return allCases
        } else {
            return [.copy, .reply]
        }
    }
}
