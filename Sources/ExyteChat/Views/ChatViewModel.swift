//
//  Created by Alex.M on 20.06.2022.
//

import Foundation
import Combine
import UIKit

@MainActor
public final class ChatViewModel: ObservableObject {

    @Published private(set) var currentUserID: UUID = UUID()
    @Published private(set) var fullscreenAttachmentItem: Optional<Attachment> = nil
    @Published var fullscreenAttachmentPresented = false

    @Published var messageMenuRow: MessageRow?
    
    /// The messages frame that is currently being rendered in the MessageProtocol Menu
    /// - Note: Used to further refine a messages frame (instead of using the cell boundary), mainly used for positioning reactions
    @Published var messageFrame: CGRect = .zero
    
    /// Provides a mechanism to issue haptic feedback to the user
    /// - Note: Used when launching the MessageMenu
    
    let inputFieldId = UUID()

    var didSendMessage: (DraftMessage) -> Void = {_ in}
    var inputViewModel: InputViewModel?
    var globalFocusState: GlobalFocusState?

    func presentAttachmentFullScreen(_ attachment: Attachment) {
        fullscreenAttachmentItem = attachment
        fullscreenAttachmentPresented = true
    }
    
    func dismissAttachmentFullScreen() {
        fullscreenAttachmentPresented = false
        fullscreenAttachmentItem = nil
    }
    
    func setCurrentUserID(_ userID: UUID) {
        DispatchQueue.main.async { [self] in
            self.currentUserID = userID
        }
    }

    func sendMessage(_ message: DraftMessage) {
        didSendMessage(message)
    }

    func messageMenuAction() -> (any MessageProtocol, DefaultMessageMenuAction) -> Void {
        { [weak self] message, action in
            self?.messageMenuActionInternal(message: message, action: action)
        }
    }

    func messageMenuActionInternal(message: any MessageProtocol, action: DefaultMessageMenuAction) {
        switch action {
        case .copy:
            UIPasteboard.general.string = message.text
        case .reply:
                inputViewModel?.attachments.replyMessage = message.toReplyMessage(current: currentUserID)
            globalFocusState?.focus = .uuid(inputFieldId)
        case .edit(let saveClosure):
            inputViewModel?.text = message.text
            inputViewModel?.edit(saveClosure)
            globalFocusState?.focus = .uuid(inputFieldId)
        }
    }
}
