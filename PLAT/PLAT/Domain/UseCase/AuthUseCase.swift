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
            isLoginComplete: false
        )
    }
}

// MARK: - State

extension AuthUseCase {
    
    struct State {
        var user: User?
        var streamAccount: StreamAccount?
        var isMember: Bool
        var isSignIn: Bool
        var isLoginComplete: Bool
    }
}

// MARK: - Effect Method

extension AuthUseCase {
    
    enum Effect {
        case signIn(socialAccout: SocialAccount)
        case signOut
        case resign
        
        case fetchProfile
        case updateProfileNickname(nickname: String)
        case updateProfileAvatar(imageUrl: String)
        
        case fetchStreamAccount
        case updateStreamAccount(streamAccount: StreamAccount)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .signIn(let socialAccount):
            Task {
                await memberService.signIn(socialAccount: socialAccount)
            }
        case .signOut:
            memberService.signOut()
        case .resign:
            Task {
                await memberService.resign()
            }
        case .fetchProfile:
            Task {
                let result = await memberService.fetchProfile()
                switch result {
                case .success(let user):
                    state.user = user
                case .failure:
                    // TODO: 에러 처리
                    break
                }
            }
        case .updateProfileNickname(nickname: let nickname):
            Task {
                let result = await memberService.updateProfileNickname(to: nickname)
                switch result {
                case .success:
                    state.user?.nickname = nickname
                case .failure:
                    // TODO: 에러 처리
                    break
                }
            }
        case .updateProfileAvatar(imageUrl: let imageUrl):
            Task {
                let result = await memberService.updateProfileAvatar(to: imageUrl)
                switch result {
                case .success:
                    state.user?.profileImageUrl = imageUrl
                case .failure:
                    // TODO: 에러 처리
                    break
                }
            }
        case .fetchStreamAccount:
            Task {
                let result = await memberService.fetchStreamAccount()
                switch result {
                case .success(let streamAccount):
                    state.streamAccount = streamAccount
                case .failure:
                    // TODO: 에러 처리
                    break
                }
            }
        case .updateStreamAccount(streamAccount: let streamAccount):
            Task {
                let result = await memberService.updateStreamAccount(to: streamAccount)
                switch result {
                case .success:
                    state.streamAccount = streamAccount
                case .failure:
                    // TODO: 에러 처리
                    break
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
