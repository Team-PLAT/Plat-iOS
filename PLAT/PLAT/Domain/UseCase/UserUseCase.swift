//
//  UserUseCase.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation

@Observable
final class UserUseCase {
    
    private var userProfileService: UserProfileServiceInterface
    
    private(set) var state: State
    
    init(userProfileService: UserProfileServiceInterface) {
        self.userProfileService = userProfileService
        self.state = State(user: userProfileService.fetchUserInfo())
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
        userProfileService.updateProfileImage()
    }
    
    /// 닉네임 변경하기
    func updateNickname() {
        userProfileService.updateNickname()
    }
    
    /// 닉네임 유효성 확인하기
    func validateNickname(text: String) -> String {
        return userProfileService.validateNickname(text: text)
    }
    
    /// 내가 게시한 트랙인지 확인하기
    func checkMyTrack(currentTrack: Track) -> Bool {
        if state.user.id == currentTrack.user.id {
            return true
        } else {
            return false
        }
    }
}
