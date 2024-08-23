//
//  AuthUseCase.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation
import AuthenticationServices

@Observable
final class AuthUseCase {
    
    private var socialLoginService: SocialLoginServiceInterface
    private var userSessionService: UserSessionServiceInterface
    private(set) var state: State
    
    init(
        authService: SocialLoginServiceInterface,
        userSessionService: UserSessionServiceInterface
    ) {
        self.socialLoginService = authService
        self.userSessionService = userSessionService
        self.state = State(
            isMember: false,
            isLoginComplete: false
        )
    }
}

// MARK: - State

extension AuthUseCase {
    
    struct State {
        var isMember: Bool
        var isLoginComplete: Bool
    }
}

// MARK: - UseCase Method

extension AuthUseCase {
    
    /// 소셜 로그인 요청하기
    func requestSocialLogin() {
        socialLoginService.requestLogin()
    }
    
    /// 소셜 로그인 결과 처리하기
    func handleSocialLogin(authResult: Result<ASAuthorization, Error>) -> Result<Bool, Error> {
        return socialLoginService.handleLogin(authResult)
    }
    
    /// 로그아웃하기
    func logout() {
        userSessionService.logout()
    }
    
    /// 회원탈퇴
    func deleteAccount() {
        userSessionService.deleteAccount()
    }
}

// MARK: - Test Method

extension AuthUseCase {
    
    /// 네비게이션 테스트용
    func updateIsLoginComplete(_ bool: Bool) {
        state.isLoginComplete = bool
    }
}
