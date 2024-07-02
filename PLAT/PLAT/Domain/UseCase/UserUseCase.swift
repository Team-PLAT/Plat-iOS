//
//  UserUseCase.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation

@Observable
final class UserUseCase {
    
    private(set) var userService: UserServiceInterface
    private(set) var state: State
    
    init(userService: UserServiceInterface) {
        self.userService = userService
        self.state = State(user: userService.fetchUserInfo())
    }
}

// MARK: - State

extension UserUseCase {
    
    struct State {
        var user: User
    }
}

// MARK: - UseCase Method

extension UserUseCase {
    
    /// 프로필 이미지 변경하기
    func updateProfileImage() {
        userService.updateProfileImage()
    }
    
    /// 닉네임 변경하기
    func updateNickname() {
        userService.updateNickname()
    }
}
