//
//  PlaylistUseCase.swift
//  PLAT
//
//  Created by 조우현 on 9/12/24.
//

import Foundation

@Observable
final class PlaylistUseCase {
    
    private let playlistService: PlaylistServiceInterface
    
    private(set) var state: State
    
    init(playlistService: PlaylistServiceInterface) {
        self.playlistService = playlistService
        self.state = State()
    }
}

// MARK: - State

extension PlaylistUseCase {
    
    struct State {
        var playlists: [Playlist] = MockDataBuilder.playlists
        var selectedPlaylistId: Playlist.ID?
    }
}

// MARK: - Effect

extension PlaylistUseCase {
    
    enum Effect {
        case updateSelectedPlaylistId(Playlist.ID)
    }
    
    func effect(_ effect: Effect) {
        switch effect {
        case .updateSelectedPlaylistId(let id):
            state.selectedPlaylistId = id
        }
    }
}

// MARK: - UseCase Method

extension PlaylistUseCase {
    
    /// 선택된 플레이리스트 반환
    var selectedPlaylist: Playlist? {
        return state.playlists.filter { $0.id == state.selectedPlaylistId }.first
    }
    
    /// 선택된 플레이리스트의 ISRC 배열 반환
    func getPlaylistIsrcs() -> [String]? {
        let isrcs = selectedPlaylist?.trackList.map { $0.music.isrc }
        print("🎀\(isrcs)")
        return isrcs
    }

    /// 플레이리스트 삭제
    func deletePlaylist() {
        playlistService.deletePlaylist()
    }
}
