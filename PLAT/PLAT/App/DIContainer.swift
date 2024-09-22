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
    private let trackService: TrackServiceInterface
    private let imageService: ImageServiceInterface
    private let playlistService: PlaylistServiceInterface
    private let userProfileService: UserProfileServiceInterface
    private let streamAccountService: StreamAccountServiceInterface
    private let trackAppendService: TrackAppendServiceInterface
    
    /// 생성 및 주입
    init() {
        self.socialLoinService = AppleSocialLoginServiceImpl()
        self.memberService = MemberServiceImpl()
        self.musicControlService = AppleMusicControllerServiceImpl()
        self.infoService = StubInfoService() // TODO: Stub 교체
        self.trackService = TrackServiceImpl()
        self.imageService = ImageServiceImpl()
        self.playlistService = StubPlaylistService() // TODO: Stub 교체
        self.userProfileService = StubUserProfileService() // TODO: Stub 교체
        self.streamAccountService = StubStreamAccountService() // TODO: Stub 교체
        self.trackAppendService = StubTrackAppendService() // TODO: Stub 교체
    }
    
    func body(content: Content) -> some View {
        content
            .environment(PathModel())
            .environment(MapUseCase())
            .environment(PlaylistUseCase(playlistService: playlistService))
            .environment(UserUseCase(userProfileService: userProfileService))
            .environment(StreamAccountUseCase(streamAccountService: streamAccountService))
            .environment(MusicControlUseCase(musicController: musicControlService))
            .environment(InfoUseCase(infoService: infoService))
            .environment(
                TrackUseCase(
                    trackService: trackService,
                    imageService: imageService
                )
            )
            .environment(
                AuthUseCase(
                    socialLoginServcie: socialLoinService,
                    memberService: memberService
                )
            )
            .environment(TrackAppendUseCase(trackAppendService: trackAppendService))
    }
}

// MARK: - Extension View Modifier

extension View {
    func injectDIContainer() -> some View {
        modifier(DIContainerModifier())
    }
}
