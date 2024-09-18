//
//  UploadImageAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/11/24.
//

import Foundation

struct UploadImageRequest: Encodable {
    let imageData: Data
}

struct UploadImageResponse: Decodable {
    let avatar: String
}
