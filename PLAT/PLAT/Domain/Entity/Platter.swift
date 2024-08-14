//
//  Platter.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation

protocol Platter {
    var nickname: String { get set }
    var profileImageUrl: String { get set }
}

struct User: Platter {
    var nickname: String
    var profileImageUrl: String
    var streamAccount: StreamAccount
}

struct Friend: Platter {
    var nickname: String
    var profileImageUrl: String
}
