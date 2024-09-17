//
//  UpdateProfileNickname.swift
//  PLAT
//
//  Created by 조우현 on 9/8/24.
//

import Foundation

struct UpdateProfileNicknameRequest: Encodable {
    let nickname: String
}

struct UpdateProfileNicknameResponse: Decodable {
    let memberId: Int64
}
