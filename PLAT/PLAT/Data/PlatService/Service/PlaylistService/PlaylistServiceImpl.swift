//
//  PlaylistServiceImpl.swift
//  PLAT
//
//  Created by 김민준 on 9/25/24.
//

import UIKit

final class PlaylistServiceImpl: PlaylistServiceInterface {
    
    private let imageService: ImageServiceInterface
    private let playlistRepository = PlaylistRepository()
    
    init(imageService: ImageServiceInterface) {
        self.imageService = imageService
    }
    
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
    func uploadPlaylist(title: String, image: UIImage?, tracks: [Track]) async -> Result<Int64, Error> {
        
        var imageUrl = ""
        
        if let image {
            let imageResult = await imageService.uploadImage(image: image)
            switch imageResult {
            case .success(let platImage): imageUrl = platImage.imageUrl
            case .failure(let imageError): return .failure(imageError)
            }
        }
        
        var trackRequest: [UploadPlaylistRequest.TracksRequest] = []
        for (index, track) in tracks.enumerated() {
            trackRequest.append(.init(trackId: track.id, orderIndex: index))
        }
        
        let request = UploadPlaylistRequest(
            title: title,
            playlistImageUrl: imageUrl,
            tracks: trackRequest
        )
        
        let response = await playlistRepository.uploadPlaylist(request: request)
        switch response {
        case .success(let response):
            let playlistId = response.playlistId
            return .success(playlistId)
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
    func updatePlaylist(playlistId: Int, title: String, image: UIImage?) async -> Result<Void, Error> {
        
        var imageUrl = ""
        
        if let image {
            let imageResult = await imageService.uploadImage(image: image)
            switch imageResult {
            case .success(let platImage): imageUrl = platImage.imageUrl
            case .failure(let imageError): return .failure(imageError)
            }
        }
        
        let request = UpdatePlaylistRequest(title: title, playlistImageUrl: imageUrl)
        let response = await playlistRepository.updatePlaylist(request: request, playlistId: Int64(playlistId))
        switch response {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 플레이리스트를 업데이트합니다. 이미지URL을 받습니다.
    func updatePlaylist(playlistId: Int, title: String, imageUrl: String?) async -> Result<Void, any Error> {

        let request = UpdatePlaylistRequest(title: title, playlistImageUrl: imageUrl ?? "")
        let response = await playlistRepository.updatePlaylist(request: request, playlistId: Int64(playlistId))
        switch response {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 플레이리스트의 트랙 순서를 변경합니다.
    func updateTrackOrder(playlistId: Int, tracks: [Track]) async -> Result<Void, Error> {
        
        var trackRequest: [UpdateTrackOrderRequest.TracksRequest] = []
        for (index, track) in tracks.enumerated() {
            trackRequest.append(.init(trackId: track.id, orderIndex: index))
        }
        
        let request = UpdateTrackOrderRequest(
            tracks: trackRequest
        )
        
        let response = await playlistRepository.updateTrackOrder(request: request, playlistId: Int64(playlistId))
        switch response {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 플레이리스트에서 트랙을 삭제합니다.
    func deleteTrackFromPlaylist(playlistId: Int, trackId: Int) async -> Result<Void, Error> {
        let response = await playlistRepository.deleteTrackFromPlaylist(playlistId: Int64(playlistId), trackId: Int64(trackId))
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
