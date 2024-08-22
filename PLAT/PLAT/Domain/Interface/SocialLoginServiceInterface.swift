//
//  SocialLoginServiceInterface.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation
import AuthenticationServices

protocol SocialLoginServiceInterface {
    func requestLogin()
    func handleLogin(_ authResult: Result<ASAuthorization, Error>) -> Result<Bool, Error>
}
