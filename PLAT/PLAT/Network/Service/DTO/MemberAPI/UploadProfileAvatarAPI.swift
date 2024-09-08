//
//  uploadProfileAvatarAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/8/24.
//

import Foundation

struct UploadProfileAvatarRequest: Encodable {
    let image: String
}

struct UploadProfileAvatarResponse: Decodable {
    let avatar: String
}
