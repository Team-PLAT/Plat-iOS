//
//  UserServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation

protocol UserServiceInterface {
    func fetchUserInfo() -> User
    func updateProfileImage()
    func updateNickname()
}
