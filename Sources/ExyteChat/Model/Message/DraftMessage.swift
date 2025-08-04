//
//  Created by Alex.M on 17.06.2022.
//

import Foundation
import GiphyUISDK
import ExyteMediaPicker

public struct DraftMessage: MessageProtocol, HasReply, Codable, Sendable {
    public var id: String
    public var user: User = .init()
    public var text: String
    public var attachments: [Attachment] = []
    public var reactions: [Reaction] = []
    public var giphyMediaId: String? = nil
    public var medias: [Media]
    public var giphyMedia: GPHMedia?
    public var recording: Recording?
    public var replyMessage: ReplyMessage?
    public var createdAt: Date
    
    public var triggerRedraw: UUID?
    
    public init(
        id: String,
        text: String,
        medias: [Media],
        giphyMedia: GPHMedia?,
        recording: Recording?,
        replyMessage: ReplyMessage?,
        createdAt: Date
    ) {
        self.id = id
        self.text = text
        self.medias = medias
        self.giphyMedia = giphyMedia
        self.recording = recording
        self.replyMessage = replyMessage
        self.createdAt = createdAt
    }
}
