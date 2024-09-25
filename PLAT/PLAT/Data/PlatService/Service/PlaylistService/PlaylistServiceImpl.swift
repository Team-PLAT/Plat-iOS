//
//  PlaylistServiceImpl.swift
//  PLAT
//
//  Created by 김민준 on 9/25/24.
//

import Foundation

final class PlaylistServiceImpl: PlaylistServiceInterface {
    
    private let playlistRepository = PlaylistRepository()
    
    /// 플레이리스트를 불러옵니다.
    func fetchPlaylists(page: Int, size: Int) async -> Result<[Playlist], any Error> {
        let request = FetchPlaylistRequest(page: page, size: size)
        let response = await playlistRepository.fetchPlaylists(request: request)
        switch response {
        case .success(let response):
            let playlists = response.playlists.map {
                Playlist(
                    id: $0.playlistId,
                    title: $0.title,
                    createdDate: $0.createdAt.iso8601ToDate,
                    imageUrl: $0.playlistImageUrl,
                    trackList: []
                )
            }
            return .success(playlists)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 플레이리스트 세부 정보를 불러옵니다.
    func fetchPlaylistDetail(playlistId: Int) async -> Result<Playlist, any Error> {
        let response = await playlistRepository.fetchPlaylistDetail(playlistId: Int64(playlistId))
        switch response {
        case .success(let response):
            
            let trackList = response.tracks.map {
                let music = Music(
                    isrc: $0.trackDetail.isrc,
                    title: "",
                    artist: "",
                    albumImageUrl: "",
                    duration: 0
                )
                
                let location = Location(
                    latitude: $0.trackDetail.latitude,
                    longitude: $0.trackDetail.longitude
                )
                
                let user = User(
                    id: Int($0.trackDetail.member.memberId),
                    nickname: $0.trackDetail.member.memberNickname,
                    profileImageUrl: $0.trackDetail.member.avatar
                )
                
                return Track(
                    id: $0.trackDetail.trackId,
                    order: $0.orderIndex,
                    music: music,
                    location: location,
                    user: user,
                    content: $0.trackDetail.content,
                    imageUrl: $0.trackDetail.imageUrl,
                    createdDate: $0.trackDetail.createdAt.iso8601ToDate,
                    isLike: $0.trackDetail.isLiked,
                    isReported: false
                )
            }
            
            let playlist = Playlist(
                id: response.playlistId,
                title: response.title,
                createdDate: response.createdAt.iso8601ToDate,
                imageUrl: response.playlistImageUrl,
                trackList: trackList
            )
            
            return .success(playlist)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 플레이리스트를 검색합니다.
    func searchPlaylist(title: String, page: Int, size: Int) async -> Result<[Playlist], any Error> {
        let request = SearchPlaylistRequest(title: title, page: page, size: size)
        let response = await playlistRepository.searchPlaylist(request: request)
        switch response {
        case .success(let response):
            let playlists = response.playlists.map {
                Playlist(
                    id: $0.playlistId,
                    title: $0.title,
                    imageUrl: $0.playlistImageUrl,
                    trackList: []
                )
            }
            
            return .success(playlists)
            
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 플레이리스트를 업로드합니다.
    func uploadPlaylist(title: String, imageUrl: String, tracks: [Track]) async -> Result<Void, any Error> {
        let trackRequest = tracks.map {
            UploadPlaylistRequest.TracksRequest(
                trackId: $0.id,
                orderIndex: $0.order
            )
        }
        
        let request = UploadPlaylistRequest(title: title, playlistImageUrl: imageUrl, tracks: trackRequest)
        let response = await playlistRepository.uploadPlaylist(request: request)
        switch response {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 플레이리스트에 트랙을 추가합니다.
    func appendTrackToPlaylist(playlistId: Int, trackId: Int) async -> Result<Void, any Error> {
        let request = AppendTrackToPlaylistRequest(trackId: Int64(trackId))
        let response = await playlistRepository.appendTrackToPlaylist(
            request: request,
            playlistId: Int64(
                playlistId
            )
        )
        
        switch response {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 플레이리스트를 업데이트합니다.
    func updatePlaylist(playlistId: Int, title: String, imageUrl: String, tracks: [Track]) async -> Result<Void, any Error> {
        let trackRequest = tracks.map {
            UpdatePlaylistRequest.TracksRequest(trackId: $0.id, orderIndex: $0.order)
        }
        let request = UpdatePlaylistRequest(title: title, playlistImageUrl: imageUrl, tracks: trackRequest)
        let response = await playlistRepository.updatePlaylist(request: request, playlistId: Int64(playlistId))
        switch response {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 플레이리스트를 삭제합니다.
    func deletePlaylist(playlistId: Int) async -> Result<Void, any Error> {
        let response = await playlistRepository.deletePlaylist(playlistId: Int64(playlistId))
        switch response {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
