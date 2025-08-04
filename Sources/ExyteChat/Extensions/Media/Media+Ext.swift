//
//  Media+Ext.swift
//  Chat
//
//  Created by Michael Shaw on 8/4/25.
//

import ExyteMediaPicker
import Foundation

extension Media {
    func toAttachment(from id: UUID) async -> Attachment? {
        guard let thumbnailURL = await self.getThumbnailURL(), let fullURL = await self.getURL() else { return nil }
        return Attachment(
            id: id,
            thumbnail: thumbnailURL,
            full: fullURL,
            type: self.type.toAttachmentType()
        )
	}
}

extension MediaType {
    func toAttachmentType() -> AttachmentType {
        switch self {
            case .image:
                    .image
            case .video:
                    .video
        }
    }
}
