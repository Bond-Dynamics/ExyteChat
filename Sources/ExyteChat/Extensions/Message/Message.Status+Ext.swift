//
//  Message.Status+Ext.swift
//  Chat
//
//  Created by Michael Shaw on 8/4/25.
//

extension Message.Status {
    var rawValue: String {
        switch self {
            case .sending:
                "SENDING"
            case .sent:
                "SENT"
            case .read:
                "READ"
            case .error(let draftMessage):
                "ERROR"
        }
    }
}
