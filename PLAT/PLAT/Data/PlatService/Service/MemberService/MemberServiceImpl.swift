//
//  MemberServiceImpl.swift
//  PLAT
//
//  Created by 김민준 on 9/15/24.
//

import UIKit

final class MemberServiceImpl: MemberServiceInterface {
    
    enum MemberServiceError: Error {
        case streamAccountError
        case noImageError
    }
    
    private let userSecurityManager = UserSecurityManager.shared
    private let memberRepository = MemberRepository()
    private let imageService: ImageServiceInterface
    
    init(imageService: ImageServiceInterface) {
        self.imageService = imageService
    }
    
    /// 로그인을 요청합니다.
    func signIn(socialAccount: SocialAccount) async -> Result<Void, any Error> {
        let request = SignInRequest(
            encryptedUserIdentifier: userSecurityManager.encryptedUserIdentifier,
            socialType: socialAccount.rawValue
        )
        let result = await memberRepository.signIn(request: request)
        switch result {
        case .success(let signInResponse):
            userSecurityManager.updateAccessToken(signInResponse.accessToken)
            userSecurityManager.updateRefreshToken(signInResponse.refreshToken)
            return .success(Void())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 로그아웃을 진행합니다.
    func signOut() {
        userSecurityManager.clearAccessToken()
        userSecurityManager.clearRefreshToken()
    }
    
    /// 회원 탈퇴를 진행합니다.
    func resign() async -> Result<Void, any Error> {
        let result = await memberRepository.resign()
        switch result {
        case .success:
            return .success(Void())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 프로필 정보를 요청합니다.
    func fetchProfile() async -> Result<User, any Error> {
        let result = await memberRepository.fetchProfile()
        switch result {
        case .success(let fetchProfileResponse):
            return .success(
                User(
                    id: Int(fetchProfileResponse.memberId),
                    nickname: fetchProfileResponse.nickname,
                    profileImageUrl: fetchProfileResponse.avatar
                )
            )
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 프로필 닉네임을 업데이트합니다.
    func updateProfileNickname(to nickname: String) async -> Result<Void, any Error> {
        let request = UpdateProfileNicknameRequest(nickname: nickname)
        let result = await memberRepository.updateProfileNickname(request: request)
        switch result {
        case .success:
            return .success(Void())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 프로필 아바타를 업데이트합니다.
    func updateProfileAvatar(to image: UIImage?) async -> Result<Void, any Error> {
        
        guard let image else {
            return .failure(MemberServiceError.noImageError)
        }
        
        let imageResult = await imageService.uploadImage(image: image)
        switch imageResult {
        case .success(let platImage):
            let request = UpdateProfileAvatarRequest(avatar: platImage.imageUrl)
            let result = await memberRepository.updateProfileAvatar(request: request)
            switch result {
            case .success:
                return .success(())
            case .failure(let error):
                return .failure(error)
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 스트리밍 계정 정보를 요청합니다.
    func fetchStreamAccount() async -> Result<StreamAccount, any Error> {
        let result = await memberRepository.fetchStreamAccount()
        switch result {
        case .success(let fetchProfileStreamTypeResponse):
            if let streamAccount = StreamAccount(rawValue: fetchProfileStreamTypeResponse.streamType) {
                return .success(streamAccount)
            } else {
                return .failure(MemberServiceError.streamAccountError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 스트리밍 계정 정보를 업데이트합니다.
    func updateStreamAccount(to streamAccount: StreamAccount) async -> Result<Void, any Error> {
        guard let streamAccount = UpdateProfileStreamTypeRequest.StreamType(rawValue: streamAccount.rawValue) else {
            return .failure(MemberServiceError.streamAccountError)
        }
        let request = UpdateProfileStreamTypeRequest(streamType: streamAccount)
        let result = await memberRepository.updateStreamAccount(request: request)
        switch result {
        case .success:
            return .success(Void())
        case .failure(let error):
            return .failure(error)
        }
    }
}
