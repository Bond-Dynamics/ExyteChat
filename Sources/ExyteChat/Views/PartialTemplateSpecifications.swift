//
//  SwiftUIView.swift
//
//
//  Created by Alisa Mylnikova on 06.12.2023.
//

import SwiftUI

public extension ChatView where MessageContent == EmptyView {

    init(messages: [any MessageProtocol],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUser: User,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         inputViewBuilder: @escaping InputViewBuilderClosure,
         messageMenuAction: MessageMenuActionClosure?,
    ) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUser.id)
        self.ids = messages.map { $0.id }
        self.inputViewBuilder = inputViewBuilder
        self.messageMenuAction = messageMenuAction
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUser(currentUser)
        }
    }
}

public extension ChatView where InputViewContent == EmptyView {

    init(messages: [any MessageProtocol],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUser: User,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         messageBuilder: @escaping MessageBuilderClosure,
         messageMenuAction: MessageMenuActionClosure?) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUser.id)
        self.ids = messages.map { $0.id }
        self.messageBuilder = messageBuilder
        self.messageMenuAction = messageMenuAction
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUser(currentUser)
        }
    }
}

public extension ChatView where MenuAction == DefaultMessageMenuAction {

    init(messages: [any MessageProtocol],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUser: User,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         messageBuilder: @escaping MessageBuilderClosure,
         inputViewBuilder: @escaping InputViewBuilderClosure) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUser.id)
        self.ids = messages.map { $0.id }
        self.messageBuilder = messageBuilder
        self.inputViewBuilder = inputViewBuilder
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUser(currentUser)
        }
    }
}

public extension ChatView where MessageContent == EmptyView, InputViewContent == EmptyView {

    init(messages: [any MessageProtocol],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUser: User,
         didSendMessage: @escaping (DraftMessage) -> Void,
         onMessageEdit: ((any MessageProtocol, String) -> Void)? = nil,
         reactionDelegate: ReactionDelegate? = nil,
         messageMenuAction: MessageMenuActionClosure?) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = onMessageEdit
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUser.id)
        self.ids = messages.map { $0.id }
        self.messageMenuAction = messageMenuAction
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUser(currentUser)
        }
    }
}

public extension ChatView where InputViewContent == EmptyView, MenuAction == DefaultMessageMenuAction {

    init(messages: [any MessageProtocol],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUser: User,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         messageBuilder: @escaping MessageBuilderClosure) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUser.id)
        self.ids = messages.map { $0.id }
        self.messageBuilder = messageBuilder
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUser(currentUser)
        }
    }
}

public extension ChatView where MessageContent == EmptyView, MenuAction == DefaultMessageMenuAction {

    init(messages: [any MessageProtocol],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUser: User,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         inputViewBuilder: @escaping InputViewBuilderClosure) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUser.id)
        self.ids = messages.map { $0.id }
        self.inputViewBuilder = inputViewBuilder
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUser(currentUser)
        }
    }
}

public extension ChatView where MessageContent == EmptyView, InputViewContent == EmptyView, MenuAction == DefaultMessageMenuAction {

    init(messages: [any MessageProtocol],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUser: User,
         didSendMessage: @escaping (DraftMessage) -> Void,
         onMessageEdit: ((any MessageProtocol, String) -> Void)? = nil,
         reactionDelegate: ReactionDelegate? = nil) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = onMessageEdit
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUser.id)
        self.ids = messages.map { $0.id }
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUser(currentUser)
        }
    }
}

// MARK: - Simplest convenience initializer (for the example usage pattern)
public extension ChatView where MessageContent == EmptyView, InputViewContent == EmptyView, MenuAction == DefaultMessageMenuAction {
    
    init(messages: [any MessageProtocol],
         chatType: ChatType = .conversation,
         didSendMessage: @escaping (DraftMessage) -> Void,
         onMessageEdit: ((any MessageProtocol, String) -> Void)? = nil,
         currentUser: User,
    ) {
        // Extract current user ID from messages
        
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = onMessageEdit
        self.reactionDelegate = nil
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: .quote, currentUserID: currentUser.id)
        self.ids = messages.map { $0.id }
        self.messageMenuAction = nil
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUser(currentUser)
        }
    }
}
