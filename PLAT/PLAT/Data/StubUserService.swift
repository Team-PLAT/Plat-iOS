//
//  StubUserService.swift
//  PLAT
//
//  Created by 조우현 on 7/6/24.
//

import Foundation

struct StubUserService: UserServiceInterface {
    func fetchUserInfo() -> User {
        return User(nickname: "IPSUM_LOREM", profileImageUrl: "", streamAccount: .appleMusic)
    }
    
    func updateProfileImage() {
        print(#function)
    }
    
    func updateNickname() {
        print(#function)
    }
}
