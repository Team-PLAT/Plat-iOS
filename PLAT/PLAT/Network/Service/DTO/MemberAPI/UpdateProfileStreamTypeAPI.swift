//
//  UpdateProfileStreamTypeAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/8/24.
//

import Foundation

struct UpdateProfileStreamTypeRequest: Encodable {
    let streamType: String
}

struct UpdateProfileStreamTypeResponse: Decodable {
    let memberId: Int64
}
