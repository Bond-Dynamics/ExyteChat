//
//  User+Ext.swift
//  ExyteChat
//
//  Created by Michael Shaw on 8/28/25.
//

public extension User {
    func with(type: UserType) -> User {
        User(id: self.id, name: self.name, avatarURL: self.avatarURL, type: type)
    }
}
