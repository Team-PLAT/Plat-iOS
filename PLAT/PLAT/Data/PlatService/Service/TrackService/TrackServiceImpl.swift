//
//  TrackServiceImpl.swift
//  PLAT
//
//  Created by 조우현 on 9/7/24.
//

import Foundation

final class TrackServiceImpl: TrackServiceInterface {
    
    private let trackRepository = TrackRepository()
    
    /// 현재 위치의 사각형을 기준으로 TrackList를 반환합니다.
    func fetchTrackList(rectLocation: RectLocation) async -> Result<[Track], any Error> {
        let request = FetchTrackMapRequest(
            startLatitude: rectLocation.startLatitude,
            startLongitude: rectLocation.startLongitude,
            endLatitude: rectLocation.endLatitude,
            endLongitude: rectLocation.endLongitude
        )
        
        let result = await trackRepository.fetchTrackMap(request: request)
        switch result {
        case .success(let fetchTrackMapResponse):
            let trackList = fetchTrackMapResponse
            return .success(trackList.toTrackList())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 지정된 페이지의 TrackList를 반환합니다.
    func fetchTrackList(page: Int) async -> Result<[Track], any Error> {
        let request = FetchTrackFeedRequest(page: Int32(page), size: 20)
        let result = await trackRepository.fetchTrackFeedList(request: request)
        switch result {
        case .success(let fetchTrackFeedResponse):
            let trackList = fetchTrackFeedResponse
            return .success(trackList.toTrackList())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// Track 정보를 패치합니다.
    func fetchDetail(track: Track) async -> Result<Track, any Error> {
        let request = FetchTrackDetailResquest(trackId: track.id)
        let result = await trackRepository.fetchTrackDetail(request: request)
        switch result {
        case .success(let fetchTrackDetailResponse):
            let track = fetchTrackDetailResponse.toTrack()
            return .success(track)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    /// 트랙을 게시합니다.
    func upload(track: Track) async -> Result<Void, any Error> {
        let request = UploadTrackRequest(
            isrc: track.music.isrc,
            imageUrl: track.imageUrl ?? "",
            content: track.content ?? "",
            latitude: track.location.latitude,
            longitude: track.location.longitude
        )
        
        let result = await trackRepository.uploadTrack(request: request)
        switch result {
        case .success: return .success(Void())
        case .failure(let error): return .failure(error)
        }
    }
    
    /// 트랙에 좋아요를 표시합니다.
    func like(track: Track) async -> Result<Void, any Error> {
        let request = LikeTrackRequest(trackId: track.id, isLiked: track.isLike)
        let result = await trackRepository.likeTrack(request: request)
        switch result {
        case .success: return .success(Void())
        case .failure(let error): return .failure(error)
        }
    }
    
    /// 트랙을 신고합니다.
    func report(track: Track) async -> Result<Void, any Error> {
        let request = ReportTrackRequset(trackId: track.id)
        let result = await trackRepository.reportTrack(request: request)
        switch result {
        case .success: return .success(Void())
        case .failure(let error): return .failure(error)
        }
    }
}
