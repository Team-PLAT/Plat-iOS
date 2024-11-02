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
        var playlists: [Playlist] = []
        var searchPlaylists: [Playlist] = []
        var selectedPlaylist: Playlist?
        var selectedPlaylistId: Playlist.ID?
        var appendTrackId: Int64?
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
        return isrcs
    }
    
    /// 플레이리스트를 불러옵니다.
    func fetchPlaylists() {
        Task {
            let result = await playlistService.fetchPlaylists(page: 0, size: 20)
            switch result {
            case .success(let playlists): state.playlists = playlists
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    /// 플레이리스트 세부 정보를 불러옵니다.
    func fetchPlaylistDetail(playlistId: Int) {
        Task {
            let result = await playlistService.fetchPlaylistDetail(playlistId: playlistId)
            switch result {
            case .success(let playlist): state.selectedPlaylist = playlist
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    /// 플레이리스트를 검색합니다.
    func searchPlaylist(title: String) {
        Task {
            let result = await playlistService.searchPlaylist(title: title, page: 0, size: 20)
            switch result {
            case .success(let playlists): state.searchPlaylists = playlists
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    /// 플레이리스트를 업로드합니다.
    func uploadPlaylist(title: String, imageData: Data?, tracks: [Track]) async -> Result<Int64, Error> {
        let result = await playlistService.uploadPlaylist(title: title, imageData: imageData, tracks: tracks)
        switch result {
        case .success(let playlistId): return .success(playlistId)
        case .failure(let error): return .failure(error)
        }
    }
    
    /// 플레이리스트에 트랙을 추가합니다.
    func appendTrackToPlaylist(trackId: Int, to playlistId: Int ) {
        Task {
            let result = await playlistService.appendTrackToPlaylist(playlistId: playlistId, trackId: trackId)
            switch result {
            case .success: break
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    /// 플레이리스트를 업데이트합니다.
    func updatePlaylist(playlistId: Int, title: String, imageData: Data?) {
        Task {
            let result = await playlistService.updatePlaylist(
                playlistId: playlistId,
                title: title,
                imageData: imageData
            )
            
            switch result {
            case .success: break
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    /// 플레이리스트의 트랙 순서를 변경합니다.
    func updateTrackOrder(playlistId: Int, tracks: [Track]) {
        Task {
            let result = await playlistService.updateTrackOrder(
                playlistId: playlistId,
                tracks: tracks
            )
            
            switch result {
            case .success: break
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    /// 플레이리스트에서 트랙을 삭제합니다.
    func deleteTrackFromPlaylist(playlistId: Int, trackId: Int) {
        Task {
            let result = await playlistService.deleteTrackFromPlaylist(
                playlistId: playlistId,
                trackId: trackId
            )
            
            switch result {
            case .success: break
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    /// 플레이리스트를 삭제합니다.
    func deletePlaylist(playlistId: Int) {
        Task {
            let result = await playlistService.deletePlaylist(playlistId: playlistId)
            switch result {
            case .success: break
            case .failure(let error): print(error) // TODO: 에러 처리
            }
        }
    }
    
    /// 피드 뷰에서 트랙을 플리에 추가할 때를 위한 함수입니다.
    func updateAppendTrackID(trackId: Int) {
        state.appendTrackId = Int64(trackId)
    }
}
