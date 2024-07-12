//
//  LoginUseCase.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation
import AuthenticationServices

@Observable
final class LoginUseCase {
    
    private(set) var loginService: LoginServiceInterface
    private(set) var state: State
    
    init(loginService: LoginServiceInterface) {
        self.loginService = loginService
        self.state = State()
    }
}

// MARK: - State

extension LoginUseCase {
    
    struct State {
        //       var isSignIn: Result<Bool, Error>
        //       var isSignUp: Result<Bool, Error>
    }
}

// MARK: - UseCase Method
extension LoginUseCase {
    
    /// 로그인 요청하기
    func requestLogin() {
        loginService.requestLogin(ASAuthorizationAppleIDProvider().createRequest())
    }
    
    /// 로그인 결과 처리하기
    func handleLogin(authResult: Result<ASAuthorization, Error>) -> Result<Bool, Error> {
        return loginService.handleLogin(authResult)
    }
}
