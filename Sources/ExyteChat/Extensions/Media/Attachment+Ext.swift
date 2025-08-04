//
//  Attachment+Ext.swift
//  Chat
//
//  Created by Michael Shaw on 8/4/25.
//

import ExyteMediaPicker

extension AttachmentType {
    func toMediaType() -> MediaType {
        switch self {
            case .image:
                .image
            case .video:
                .video
        }
    }
}
