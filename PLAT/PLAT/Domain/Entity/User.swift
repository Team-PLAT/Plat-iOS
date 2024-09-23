//
//  Platter.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation

struct User: Identifiable {
    let id: UUID
    var nickname: String
    var profileImageUrl: String
    
    init(nickname: String, profileImageUrl: String) {
        self.id = UUID()
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }
}
