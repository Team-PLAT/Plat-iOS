//
//  FetchProfileAPI.swift
//  PLAT
//
//  Created by 조우현 on 9/8/24.
//

import Foundation

struct FetchProfileResponse: Decodable {
    let memberId: Int64
    let nickname: String
    let avatar: String
}
