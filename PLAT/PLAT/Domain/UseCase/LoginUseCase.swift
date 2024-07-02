//
//  LoginUseCase.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation

@Observable
final class LoginUseCase {
    
    private(set) var loginService: LoginServiceInterface
    
    init(loginService: LoginServiceInterface) {
        self.loginService = loginService
    }
}

// MARK: - UseCase Method

extension LoginUseCase {
    
    /// 로그인하기
    func signIn() {
        loginService.signIn()
    }
    
    /// 회원가입하기
    func signUp() {
        loginService.signUp()
    }
}
