//
//  Helper+Preview.swift
//  PLAT
//
//  Created by 조우현 on 7/7/24.
//

import Foundation

// MARK: - Preview를 위한 주입용 Mock 객체

#if DEBUG
enum PreviewHelper {
    static let mockUserUseCase = UserUseCase(
        userProfileService: StubUserProfileService()
    )
    
    static let mockInfoUseCase = InfoUseCase(
        infoService: StubInfoService()
    )
    
    static let mockStreamAccountUseCase = StreamAccountUseCase(
        streamAccountService: StubStreamAccountService()
    )
    
    static let mockAuthUseCase = AuthUseCase(
        authService: AppleSocialLoginService(),
        userSessionService: StubUserSessionService()
    )
    
    static let mockTrackDetailUseCase = TrackDetailUseCase(
        feedTrack: MockDataBuilder.feedTrack,
        track: MockDataBuilder.track,
        trackService: StubTrackService(),
        trackId: MockDataBuilder.track.id
    )
    
    static let mockTrackMapUseCase = TrackMapUseCase(
        trackMapService: StubTrackMapService()
    )
    
    static let mockMusicControlUseCase = MusicControlUseCase(
        musicController: StubMusicController()
    )
    
    static let mockPlaylistUseCase = PlaylistUseCase(
        playlistService: StubPlaylistService()
    )
}
#endif
