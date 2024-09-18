//
//  PlaylistUseCase.swift
//  PLAT
//
//  Created by 조우현 on 9/12/24.
//

import Foundation

@Observable
final class PlaylistUseCase {
    
    private(set) var playlistService: PlaylistServiceInterface
    
    private(set) var state: State
    
    init(playlistService: PlaylistServiceInterface) {
        self.playlistService = playlistService
        self.state = State()
    }
}

// MARK: - State

extension PlaylistUseCase {
    
    struct State {
        
    }
}

// MARK: - UseCase Method

extension PlaylistUseCase {
    
    /// 플레이리스트를 기기에서 재생
    func playOnDevice() {
        playlistService.playOnDevice()
    }
    
    /// 플레이리스트 삭제
    func deletePlaylist() {
        playlistService.deletePlaylist()
    }
}
