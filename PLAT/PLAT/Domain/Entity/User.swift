//
//  Platter.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation

struct User: Identifiable {
    let id: Int
    var nickname: String
    var profileImageUrl: String
    
    init(id: Int, nickname: String, profileImageUrl: String) {
        self.id = id
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
    }
}
