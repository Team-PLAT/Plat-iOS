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
    private var memberService: MemberServiceInterface
    private(set) var state: State
    
    init(
        socialLoginServcie: SocialLoginServiceInterface,
        memberService: MemberServiceInterface
    ) {
        self.socialLoginService = socialLoginServcie
        self.memberService = memberService
        self.state = State(
            isMember: false,
            isSignIn: false,
            isLoginComplete: false,
            currentUserId: UUID()
        )
    }
}

// MARK: - State

extension AuthUseCase {
    
    struct State {
        var user: User?
        var authType: AuthType = .signUp
        var streamAccount: StreamAccount?
        var isMember: Bool
        var isSignIn: Bool
        var isLoginComplete: Bool
        var currentUserId: UUID // TODO: 로그인 이후 로직이.. 어떻게 되는지.. state 수정해야해!
    }
}

// MARK: - UseCase Method

extension AuthUseCase {
    
    /// 로그인을 요청합니다.
    func signIn(socialAccount: SocialAccount) async -> Result<Void, Error> {
        let result = await memberService.signIn(socialAccount: socialAccount)
        switch result {
        case .success: return .success(())
        case .failure(let error): return .failure(error)
        }
    }
}

// MARK: - Effect Method

extension AuthUseCase {
    
    enum Effect {
        case toggleAuthType(_ authType: AuthType)
        case signOut
        case resign
        
        case fetchProfile
        case updateProfileNickname(nickname: String)
        case updateProfileAvatar(imageData: Data)
        
        case fetchStreamAccount
        case updateStreamAccount(streamAccount: StreamAccount)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .toggleAuthType(let authType):
            state.authType = authType
            
        case .signOut:
            memberService.signOut()
            state.isLoginComplete = false
            
        case .resign:
            Task {
                let result = await memberService.resign()
                switch result {
                case .success: break
                case .failure(let error): print(error) // TODO: 에러 처리
                }
            }
            
        case .fetchProfile:
            Task {
                let result = await memberService.fetchProfile()
                switch result {
                case .success(let user):
                    state.user = user
                    
                case .failure(let error):
                    print(error) // TODO: 에러 처리
                }
            }
            
        case .updateProfileNickname(let nickname):
            Task {
                let result = await memberService.updateProfileNickname(to: nickname)
                switch result {
                case .success:
                    state.user?.nickname = nickname
                    
                case .failure(let error):
                    print(error) // TODO: 에러 처리
                }
            }
            
        case .updateProfileAvatar(let imageData):
            Task {
                let result = await memberService.updateProfileAvatar(to: imageData)
                switch result {
                case .success:
                    break
                    
                case .failure(let error):
                    print(error) // TODO: 에러 처리
                }
            }
            
        case .fetchStreamAccount:
            Task {
                let result = await memberService.fetchStreamAccount()
                switch result {
                case .success(let streamAccount):
                    state.streamAccount = streamAccount
                    
                case .failure(let error):
                    print(error) // TODO: 에러 처리
                }
            }
            
        case .updateStreamAccount(streamAccount: let streamAccount):
            Task {
                let result = await memberService.updateStreamAccount(to: streamAccount)
                switch result {
                case .success:
                    state.streamAccount = streamAccount
                    
                case .failure(let error):
                    print(error) // TODO: 에러 처리
                }
            }
        }
    }
}

// MARK: - Social Login (추후 Effect 메서드로 빼기)

extension AuthUseCase {
    
    /// 소셜 로그인 요청하기
    func requestSocialLogin() {
        socialLoginService.requestLogin()
    }
    
    /// 소셜 로그인 결과 처리하기
    func handleSocialLogin(authResult: Result<ASAuthorization, Error>) -> Result<Bool, Error> {
        return socialLoginService.handleLogin(authResult)
    }
}

// MARK: - Test Method

extension AuthUseCase {
    
    /// 네비게이션 테스트용
    func updateIsLoginComplete(_ bool: Bool) {
        state.isLoginComplete = bool
    }
}
