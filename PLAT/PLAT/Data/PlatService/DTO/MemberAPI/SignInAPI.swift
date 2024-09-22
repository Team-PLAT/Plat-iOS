//
//  SignInAPI.swift
//  PLAT
//
//  Created by 김민준 on 9/15/24.
//

import Foundation

struct SignInRequest: Encodable {
    let encryptedUserIdentifier: String
    let socialType: String
}

struct SignInResponse: Decodable {
    let memberId: Int64
    let accessToken: String
    let refreshToken: String
    let isServiced: Bool
}
