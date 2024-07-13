//
//  LoginService.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation
import AuthenticationServices

struct LoginService: LoginServiceInterface {
    
    /// 로그인 요청했을 때 호출
    func requestLogin(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    /// 로그인 완료됐을 때 호출
    func handleLogin(_ authResult: Result<ASAuthorization, Error>) -> Result<Bool, Error> {
        switch authResult {
        case .success(let auth):
            print("성공", auth)
            
            switch auth.credential {
            case _ as ASAuthorizationAppleIDCredential:
                // 가져올 수 있는 정보
//                let userIdentifier = appleIDCredential.user
//                let fullName = appleIDCredential.fullName
//                let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
//                let email = appleIDCredential.email
//                let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
//                let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                return .success(true)
                
            default:
                return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "알 수 없는 인증 유형"]))
            }
        case .failure(let error):
            print("실패", error.localizedDescription)
            return .failure(error)
        }
    }
}
