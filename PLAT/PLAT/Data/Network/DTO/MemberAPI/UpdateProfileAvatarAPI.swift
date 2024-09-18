//
//  UpdateProfileAvatarAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/8/24.
//

import Foundation

struct UpdateProfileAvatarRequest: Encodable {
    let avatar: String
}

struct UpdateProfileAvatarResponse: Decodable {
    let memberId: Int64
}
