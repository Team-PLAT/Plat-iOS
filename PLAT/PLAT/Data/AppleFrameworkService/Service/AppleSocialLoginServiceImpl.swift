//
//  AppleSocialLoginServiceImpl.swift
//  PLAT
//
//  Created by 김민준 on 7/2/24.
//

import Foundation
import AuthenticationServices

struct AppleSocialLoginServiceImpl: SocialLoginServiceInterface {
    
    /// 로그인 요청했을 때 호출
    func requestLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
    }
    
    /// 로그인 완료됐을 때 호출
    func handleLogin(_ authResult: Result<ASAuthorization, Error>) -> Result<Bool, Error> {
        switch authResult {
        case .success(let auth):
            switch auth.credential {
            case let(credential) as ASAuthorizationAppleIDCredential:
                UserSecurityManager.shared.updateEncryptedUserIdentifier(credential.user)
                return .success(true)
                
            default:
                return .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "알 수 없는 인증 유형"]))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
