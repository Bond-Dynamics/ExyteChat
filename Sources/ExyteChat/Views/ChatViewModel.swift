//
//  Created by Alex.M on 20.06.2022.
//

import Foundation
import Combine
import UIKit

@MainActor
@Observable
public final class ChatViewModel {

    private(set) var currentUser: User = User()
    private(set) var fullscreenAttachmentItem: Optional<Attachment> = nil
    var fullscreenAttachmentPresented = false

    var messageMenuRow: MessageRow?
    
    /// The messages frame that is currently being rendered in the MessageProtocol Menu
    /// - Note: Used to further refine a messages frame (instead of using the cell boundary), mainly used for positioning reactions
    var messageFrame: CGRect = .zero
    
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
    
    func setCurrentUser(_ user: User) {
        DispatchQueue.main.async { [self] in
            self.currentUser = user
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
                inputViewModel?.attachments.replyMessage = message.toReplyMessage(current: currentUser)
            globalFocusState?.focus = .uuid(inputFieldId)
        case .edit(let saveClosure):
            inputViewModel?.text = message.text
            inputViewModel?.edit(saveClosure)
            globalFocusState?.focus = .uuid(inputFieldId)
        }
    }
}
