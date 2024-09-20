//
//  DIContainer.swift
//  PLAT
//
//  Created by 김민준 on 9/20/24.
//

import SwiftUI

struct DIContainerModifier: ViewModifier {
    
    private let socialLoinService: SocialLoginServiceInterface
    private let memberService: MemberServiceInterface
    private let musicControlService: MusicControllerInterface
    private let infoService: InfoServiceInterface
    
    /// 생성 및 주입
    init() {
        self.socialLoinService = AppleSocialLoginService()
        self.memberService = MemberServiceImpl()
        self.musicControlService = AppleMusicController()
        self.infoService = StubInfoService() // TODO: Stub 교체
    }
    
    func body(content: Content) -> some View {
        content
            .environment(PathModel())
            .environment(
                AuthUseCase(
                    socialLoginServcie: socialLoinService,
                    memberService: memberService
                )
            )
            .environment(
                MusicControlUseCase(
                    musicController: musicControlService
                )
            )
            .environment(
                InfoUseCase(
                    infoService: infoService
                )
            )
    }
}

// MARK: - Extension View Modifier

extension View {
    func injectDIContainer() -> some View {
        modifier(DIContainerModifier())
    }
}
