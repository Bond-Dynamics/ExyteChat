//
//  EditingExample.swift
//  ExyteChat
//
//  Example demonstrating message editing functionality
//

import SwiftUI
import ExyteChat

struct EditingExample: View {
    @State private var messages: [Message] = []
    @State private var isEditing = false
    @State private var messageToEdit: (any MessageProtocol)?
    @State private var editingText = ""
    
    private let currentUser = User(id: UUID(), name: "Current User", avatarURL: nil, isCurrentUser: true)
    private let otherUser = User(id: UUID(), name: "Other User", avatarURL: nil, isCurrentUser: false)
    
    var body: some View {
        NavigationView {
            ChatView(
                messages: messages,
                chatType: .conversation,
                didSendMessage: { draft in
                    // Handle new message
                    let newMessage = Message(
                        id: draft.id,
                        user: currentUser,
                        status: .sent,
                        createdAt: draft.createdAt,
                        text: draft.text,
                        attachments: draft.medias.map { Attachment(id: UUID(), url: $0.getURL(), type: .image) },
                        recording: draft.recording,
                        replyMessage: draft.replyMessage.map { ReplyMessage(id: $0.id, user: $0.user, text: $0.text, attachments: $0.attachments, recording: $0.recording) }
                    )
                    messages.append(newMessage)
                },
                onMessageEdit: { editedMessage, newText in
                    // Handle message edit
                    if let index = messages.firstIndex(where: { $0.id == editedMessage.id }) {
                        var updatedMessage = messages[index]
                        updatedMessage.text = newText
                        messages[index] = updatedMessage
                    }
                },
                isEditingMessage: $isEditing,
                messageBeingEdited: $messageToEdit,
                editingText: $editingText
            )
            .navigationTitle("Editing Example")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit Last") {
                        if let lastMessage = messages.last(where: { $0.user.isCurrentUser }) {
                            startEditing(message: lastMessage)
                        }
                    }
                }
            }
        }
        .onAppear {
            setupSampleMessages()
        }
    }
    
    private func startEditing(message: any MessageProtocol) {
        messageToEdit = message
        editingText = message.text
        isEditing = true
    }
    
    private func setupSampleMessages() {
        messages = [
            Message(
                id: UUID(),
                user: otherUser,
                status: .read,
                createdAt: Date().addingTimeInterval(-3600),
                text: "Hello! How are you today?"
            ),
            Message(
                id: UUID(),
                user: currentUser,
                status: .sent,
                createdAt: Date().addingTimeInterval(-3400),
                text: "I'm doing great, thanks for asking!"
            ),
            Message(
                id: UUID(),
                user: otherUser,
                status: .read,
                createdAt: Date().addingTimeInterval(-3200),
                text: "That's wonderful to hear. What have you been up to?"
            ),
            Message(
                id: UUID(),
                user: currentUser,
                status: .sent,
                createdAt: Date().addingTimeInterval(-3000),
                text: "Just working on some exciting projects. Tap 'Edit Last' to try editing this message!"
            )
        ]
    }
}

#Preview {
    EditingExample()
}