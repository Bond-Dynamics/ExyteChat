//
//  SwiftUIView.swift
//
//
//  Created by Alisa Mylnikova on 06.12.2023.
//

import SwiftUI

public extension ChatView where MessageContent == EmptyView {

    init(messages: [MessageData],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUserID: UUID,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         inputViewBuilder: @escaping InputViewBuilderClosure,
         messageMenuAction: MessageMenuActionClosure?,
    ) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self._isEditingMessage = .constant(false)
        self._messageBeingEdited = .constant(nil)
        self._editingText = .constant("")
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUserID)
        self.ids = messages.map { $0.id }
        self.inputViewBuilder = inputViewBuilder
        self.messageMenuAction = messageMenuAction
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUserID(currentUserID)
        }
    }
}

public extension ChatView where InputViewContent == EmptyView {

    init(messages: [MessageData],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUserID: UUID,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         messageBuilder: @escaping MessageBuilderClosure,
         messageMenuAction: MessageMenuActionClosure?) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self._isEditingMessage = .constant(false)
        self._messageBeingEdited = .constant(nil)
        self._editingText = .constant("")
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUserID)
        self.ids = messages.map { $0.id }
        self.messageBuilder = messageBuilder
        self.messageMenuAction = messageMenuAction
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUserID(currentUserID)
        }
    }
}

public extension ChatView where MenuAction == DefaultMessageMenuAction {

    init(messages: [MessageData],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUserID: UUID,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         messageBuilder: @escaping MessageBuilderClosure,
         inputViewBuilder: @escaping InputViewBuilderClosure) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self._isEditingMessage = .constant(false)
        self._messageBeingEdited = .constant(nil)
        self._editingText = .constant("")
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUserID)
        self.ids = messages.map { $0.id }
        self.messageBuilder = messageBuilder
        self.inputViewBuilder = inputViewBuilder
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUserID(currentUserID)
        }
    }
}

public extension ChatView where MessageContent == EmptyView, InputViewContent == EmptyView {

    init(messages: [MessageData],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUserID: UUID,
         didSendMessage: @escaping (DraftMessage) -> Void,
         onMessageEdit: ((any MessageProtocol, String) -> Void)? = nil,
         isEditingMessage: Binding<Bool> = .constant(false),
         messageBeingEdited: Binding<(any MessageProtocol)?> = .constant(nil),
         editingText: Binding<String> = .constant(""),
         reactionDelegate: ReactionDelegate? = nil,
         messageMenuAction: MessageMenuActionClosure?) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = onMessageEdit
        self._isEditingMessage = isEditingMessage
        self._messageBeingEdited = messageBeingEdited
        self._editingText = editingText
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUserID)
        self.ids = messages.map { $0.id }
        self.messageMenuAction = messageMenuAction
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUserID(currentUserID)
        }
    }
}

public extension ChatView where InputViewContent == EmptyView, MenuAction == DefaultMessageMenuAction {

    init(messages: [MessageData],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUserID: UUID,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         messageBuilder: @escaping MessageBuilderClosure) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self._isEditingMessage = .constant(false)
        self._messageBeingEdited = .constant(nil)
        self._editingText = .constant("")
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUserID)
        self.ids = messages.map { $0.id }
        self.messageBuilder = messageBuilder
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUserID(currentUserID)
        }
    }
}

public extension ChatView where MessageContent == EmptyView, MenuAction == DefaultMessageMenuAction {

    init(messages: [MessageData],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUserID: UUID,
         didSendMessage: @escaping (DraftMessage) -> Void,
         reactionDelegate: ReactionDelegate? = nil,
         inputViewBuilder: @escaping InputViewBuilderClosure) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = nil
        self._isEditingMessage = .constant(false)
        self._messageBeingEdited = .constant(nil)
        self._editingText = .constant("")
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUserID)
        self.ids = messages.map { $0.id }
        self.inputViewBuilder = inputViewBuilder
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUserID(currentUserID)
        }
    }
}

public extension ChatView where MessageContent == EmptyView, InputViewContent == EmptyView, MenuAction == DefaultMessageMenuAction {

    init(messages: [MessageData],
         chatType: ChatType = .conversation,
         replyMode: ReplyMode = .quote,
         currentUserID: UUID,
         didSendMessage: @escaping (DraftMessage) -> Void,
         onMessageEdit: ((any MessageProtocol, String) -> Void)? = nil,
         isEditingMessage: Binding<Bool> = .constant(false),
         messageBeingEdited: Binding<(any MessageProtocol)?> = .constant(nil),
         editingText: Binding<String> = .constant(""),
         reactionDelegate: ReactionDelegate? = nil) {
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = onMessageEdit
        self._isEditingMessage = isEditingMessage
        self._messageBeingEdited = messageBeingEdited
        self._editingText = editingText
        self.reactionDelegate = reactionDelegate
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: replyMode, currentUserID: currentUserID)
        self.ids = messages.map { $0.id }
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUserID(currentUserID)
        }
    }
}

// MARK: - Simplest convenience initializer (for the example usage pattern)
public extension ChatView where MessageContent == EmptyView, InputViewContent == EmptyView, MenuAction == DefaultMessageMenuAction {
    
    init(messages: [MessageData],
         chatType: ChatType = .conversation,
         didSendMessage: @escaping (DraftMessage) -> Void,
         onMessageEdit: ((any MessageProtocol, String) -> Void)? = nil,
         isEditingMessage: Binding<Bool> = .constant(false),
         messageBeingEdited: Binding<(any MessageProtocol)?> = .constant(nil),
         editingText: Binding<String> = .constant("")) {
        // Extract current user ID from messages
        let currentUserID = messages.first(where: { $0.user.isCurrentUser })?.user.id ?? UUID()
        
        self.type = chatType
        self.didSendMessage = didSendMessage
        self.onMessageEdit = onMessageEdit
        self._isEditingMessage = isEditingMessage
        self._messageBeingEdited = messageBeingEdited
        self._editingText = editingText
        self.reactionDelegate = nil
        self.sections = ChatView.mapMessages(messages, chatType: chatType, replyMode: .quote, currentUserID: currentUserID)
        self.ids = messages.map { $0.id }
        self.messageMenuAction = nil
        
        DispatchQueue.main.async { [self] in
            self.viewModel.setCurrentUserID(currentUserID)
        }
    }
}